provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/mdn-infra"
    region = "us-west-2"
  }
}

module "datadog" {
  source      = "./modules/datadog"
  external_id = "${var.datadog_external_id}"
}

module "mdn_shared" {
  source  = "./modules/shared"
  enabled = "${lookup(var.features, "shared-infra")}"
  region  = "${var.region}"
}

module "rds-backups" {
  source = "./modules/rds-backups"
  region = "us-west-2"
}

module "security" {
  source           = "./modules/security"
  us-west-2-vpc-id = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
}

module "mdn_cdn" {
  source      = "./modules/mdn-cdn"
  enabled     = "${lookup(var.features, "cdn")}"
  region      = "${var.region}"
  environment = "stage"

  # Primary CDN
  cloudfront_primary_enabled           = "${lookup(var.cloudfront_primary, "enabled")}"
  acm_primary_cert_arn                 = "${data.aws_acm_certificate.stage-primary-cdn-cert.arn}"
  cloudfront_primary_distribution_name = "${lookup(var.cloudfront_primary, "distribution_name")}"
  cloudfront_primary_aliases           = "${split(",", lookup(var.cloudfront_primary, "aliases.stage"))}"
  cloudfront_primary_domain_name       = "${lookup(var.cloudfront_primary, "domain.stage")}"
  cloudfront_primary_api_bucket        = "${lookup(var.cloudfront_primary, "api_bucket.stage")}"

  # attachment CDN
  cloudfront_attachments_enabled           = "0"                                                                  # Disable for stage
  acm_attachments_cert_arn                 = "${data.aws_acm_certificate.attachment-cdn-cert.arn}"
  cloudfront_attachments_distribution_name = "${lookup(var.cloudfront_attachments, "distribution_name")}"
  cloudfront_attachments_aliases           = "${split(",", lookup(var.cloudfront_attachments, "aliases.stage"))}"
  cloudfront_attachments_domain_name       = "${lookup(var.cloudfront_attachments, "domain.stage")}"

  # wiki CDN
  cloudfront_wiki_enabled           = "${lookup(var.cloudfront_wiki, "enabled")}"
  acm_wiki_cert_arn                 = "${data.aws_acm_certificate.stage-wiki-cdn-cert.arn}"
  cloudfront_wiki_distribution_name = "${lookup(var.cloudfront_wiki, "distribution_name")}"
  cloudfront_wiki_aliases           = "${split(",", lookup(var.cloudfront_wiki, "aliases.stage"))}"
  cloudfront_wiki_origin_domain     = "${lookup(var.cloudfront_wiki, "domain.stage")}"

  # media CDN
  cloudfront_media_enabled = "${lookup(var.cloudfront_media, "enabled")}"
  acm_media_cert_arn       = "${data.aws_acm_certificate.stage-media-cdn-cert.arn}"
  cloudfront_media_aliases = "${split(",", lookup(var.cloudfront_media, "aliases.stage"))}"
  cloudfront_media_bucket  = "${module.media-bucket-stage.bucket_name}"
}

module "mdn_cdn_prod" {
  source      = "./modules/mdn-cdn"
  enabled     = "${lookup(var.features, "cdn")}"
  region      = "${var.region}"
  environment = "prod"

  # Primary CDN
  cloudfront_primary_enabled           = "${lookup(var.cloudfront_primary, "enabled")}"
  acm_primary_cert_arn                 = "${data.aws_acm_certificate.prod-primary-cdn-cert.arn}"
  cloudfront_primary_distribution_name = "${lookup(var.cloudfront_primary, "distribution_name")}"
  cloudfront_primary_aliases           = "${split(",", lookup(var.cloudfront_primary, "aliases.prod"))}"
  cloudfront_primary_domain_name       = "${lookup(var.cloudfront_primary, "domain.prod")}"
  cloudfront_primary_api_bucket        = "${lookup(var.cloudfront_primary, "api_bucket.prod")}"

  # attachment CDN
  cloudfront_attachments_enabled           = "${lookup(var.cloudfront_attachments, "enabled")}"
  acm_attachments_cert_arn                 = "${data.aws_acm_certificate.attachment-cdn-cert.arn}"
  cloudfront_attachments_distribution_name = "${lookup(var.cloudfront_attachments, "distribution_name")}"
  cloudfront_attachments_aliases           = "${split(",", lookup(var.cloudfront_attachments, "aliases.prod"))}"
  cloudfront_attachments_domain_name       = "${lookup(var.cloudfront_attachments, "domain.prod")}"

  # wiki CDN
  cloudfront_wiki_enabled           = "${lookup(var.cloudfront_wiki, "enabled")}"
  acm_wiki_cert_arn                 = "${data.aws_acm_certificate.prod-wiki-cdn-cert.arn}"
  cloudfront_wiki_distribution_name = "${lookup(var.cloudfront_wiki, "distribution_name")}"
  cloudfront_wiki_aliases           = "${split(",", lookup(var.cloudfront_wiki, "aliases.prod"))}"
  cloudfront_wiki_origin_domain     = "${lookup(var.cloudfront_wiki, "domain.prod")}"

  # media CDN
  cloudfront_media_enabled = "${lookup(var.cloudfront_media, "enabled")}"
  acm_media_cert_arn       = "${data.aws_acm_certificate.prod-media-cdn-cert.arn}"
  cloudfront_media_aliases = "${split(",", lookup(var.cloudfront_media, "aliases.prod"))}"
  cloudfront_media_bucket  = "${module.media-bucket-prod.bucket_name}"
}

module "lambda-log" {
  source             = "./modules/lambda-log-processor"
  source_bucket      = "${module.mdn_cdn_prod.cdn-primary-logging-bucket}"
  destination_bucket = "mdn-cdn-primary-processed"
}

# TODO: Split this up into multiple files other stuff can get messy quick
# Multi region resources

module "efs-us-west-2" {
  source               = "./modules/multi_region/efs"
  enabled              = "${lookup(var.features, "efs")}"
  environment          = "stage"
  region               = "us-west-2"
  efs_name             = "stage"
  subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.us-west-2-nodes_sg.ids}"
}

module "efs-us-west-2-prod" {
  source      = "./modules/multi_region/efs"
  enabled     = "${lookup(var.features, "efs")}"
  environment = "prod"
  region      = "us-west-2"
  efs_name    = "prod"
  subnets     = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"

  nodes_security_group = [
    "${data.aws_security_groups.us-west-2-nodes_sg.ids}",
    "${data.terraform_remote_state.eks-us-west-2.mdn_apps_a_worker_security_group_id}",
  ]
}

module "efs-eu-central-1-prod" {
  source               = "./modules/multi_region/efs"
  enabled              = "${lookup(var.features, "efs")}"
  environment          = "prod"
  region               = "eu-central-1"
  efs_name             = "prod"
  subnets              = "${join(",", data.terraform_remote_state.vpc-eu-central-1.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.eu-central-1-nodes_sg.ids}"
}

module "redis-us-west-2" {
  source               = "./modules/multi_region/redis"
  enabled              = "${lookup(var.features, "redis")}"
  environment          = "stage"
  region               = "us-west-2"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  redis_name           = "mdn-redis-stage"
  redis_node_size      = "${lookup(var.redis, "node_size.stage")}"
  redis_num_nodes      = "${lookup(var.redis, "num_nodes.stage")}"
  subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.us-west-2-nodes_sg.ids}"
}

module "redis-stage-us-west-2" {
  source               = "./modules/multi_region/redis"
  enabled              = "${lookup(var.features, "redis")}"
  environment          = "stage"
  region               = "us-west-2"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  redis_name           = "mdn-stage"
  redis_node_size      = "cache.t3.medium"
  redis_num_nodes      = "3"
  subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.us-west-2-nodes_sg.ids}"
}

module "redis-prod-us-west-2" {
  source               = "./modules/multi_region/redis"
  enabled              = "${lookup(var.features, "redis")}"
  environment          = "prod"
  region               = "us-west-2"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  redis_name           = "mdn-prod"
  redis_node_size      = "cache.m5.large"
  redis_num_nodes      = "3"
  subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.us-west-2-nodes_sg.ids}"
}

module "redis-us-west-2-prod" {
  source               = "./modules/multi_region/redis"
  enabled              = "${lookup(var.features, "redis")}"
  environment          = "prod"
  region               = "us-west-2"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  redis_name           = "mdn-redis-prod"
  redis_node_size      = "${lookup(var.redis, "node_size.prod")}"
  redis_num_nodes      = "${lookup(var.redis, "num_nodes.prod")}"
  subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.us-west-2-nodes_sg.ids}"
}

module "redis-eu-central-1-prod" {
  source               = "./modules/multi_region/redis"
  enabled              = "${lookup(var.features, "redis")}"
  environment          = "prod"
  region               = "eu-central-1"
  azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  redis_name           = "mdn-redis-prod"
  redis_node_size      = "${lookup(var.redis, "node_size.prod")}"
  redis_num_nodes      = "${lookup(var.redis, "num_nodes.prod")}"
  subnets              = "${join(",", data.terraform_remote_state.vpc-eu-central-1.public_subnets)}"
  nodes_security_group = "${data.aws_security_groups.eu-central-1-nodes_sg.ids}"
}

module "mysql-us-west-2" {
  source                      = "./modules/multi_region/rds"
  enabled                     = "${lookup(var.features, "rds")}"
  environment                 = "stage"
  region                      = "us-west-2"
  mysql_env                   = "stage"
  mysql_db_name               = "${lookup(var.rds, "db_name.stage")}"
  mysql_username              = "${lookup(var.rds, "username.stage")}"
  mysql_password              = "${lookup(var.rds, "password.stage")}"
  mysql_identifier            = "mdn-stage"
  mysql_engine_version        = "${lookup(var.rds, "engine_version.stage")}"
  mysql_instance_class        = "${lookup(var.rds, "instance_class.stage")}"
  mysql_backup_retention_days = "${lookup(var.rds, "backup_retention_days.stage")}"
  mysql_security_group_name   = "mdn_rds_sg_stage"
  mysql_storage_gb            = "${lookup(var.rds, "storage_gb.stage")}"
  mysql_storage_type          = "${lookup(var.rds, "storage_type")}"
  vpc_id                      = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  vpc_cidr                    = "${data.aws_vpc.cidr.cidr_block}"
  subnets                     = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  monitoring_interval         = "60"
}

module "mysql-us-west-2-prod" {
  source                      = "./modules/multi_region/rds"
  enabled                     = "${lookup(var.features, "rds")}"
  environment                 = "prod"
  region                      = "us-west-2"
  mysql_env                   = "prod"
  mysql_db_name               = "${lookup(var.rds, "db_name.prod")}"
  mysql_username              = "${lookup(var.rds, "username.prod")}"
  mysql_password              = "${lookup(var.rds, "password.prod")}"
  mysql_identifier            = "mdn-prod"
  mysql_engine_version        = "${lookup(var.rds, "engine_version.prod")}"
  mysql_instance_class        = "${lookup(var.rds, "instance_class.prod")}"
  mysql_backup_retention_days = "${lookup(var.rds, "backup_retention_days.prod")}"
  mysql_security_group_name   = "mdn_rds_sg_prod"
  mysql_storage_gb            = "${lookup(var.rds, "storage_gb.prod")}"
  mysql_storage_type          = "${lookup(var.rds, "storage_type")}"
  vpc_id                      = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  vpc_cidr                    = "${data.aws_vpc.cidr.cidr_block}"
  subnets                     = "${join(",", data.terraform_remote_state.vpc-us-west-2.public_subnets)}"
  monitoring_interval         = "60"
}

# Replica set
module "mysql-eu-central-1-replica-prod" {
  source              = "./modules/multi_region/rds-replica"
  environment         = "prod"
  region              = "eu-central-1"
  subnets             = "${join(",", data.terraform_remote_state.vpc-eu-central-1.public_subnets)}"
  replica_source_db   = "${module.mysql-us-west-2-prod.rds_arn}"
  vpc_id              = "${data.terraform_remote_state.vpc-eu-central-1.vpc_id}"
  kms_key_id          = "${lookup(var.rds, "key_id.eu-central-1")}"                                 # Less than ideal this key is copied from the console
  instance_class      = "${lookup(var.rds, "instance_class.prod")}"
  monitoring_interval = "60"
}

module "metrics" {
  source = "./modules/metrics"
}

# Media buckets
module "media-bucket-stage" {
  source      = "./modules/mdn-media"
  bucket_name = "mdn-media"
  environment = "stage"
}

module "media-bucket-prod" {
  source      = "./modules/mdn-media"
  bucket_name = "mdn-media"
  environment = "prod"
}

module "upload-user-stage" {
  source      = "./modules/mdn-uploader"
  name        = "mdn-uploader"
  environment = "stage"

  iam_policies = [
    "${module.media-bucket-stage.bucket_iam_policy}",
    "${module.mdn_cdn.cdn-media-iam-policy}",
  ]

  eks_worker_role_arn = [
    "${data.terraform_remote_state.kops-us-west-2.nodes_role_arn}",
    "${data.terraform_remote_state.kops-eu-central-1.nodes_role_arn}",
    "${data.terraform_remote_state.eks-us-west-2.developer_portal_worker_iam_role_arn}",
    "${data.terraform_remote_state.eks-us-west-2.mdn_apps_a_worker_iam_role_arn}",
  ]
}

module "upload-user-prod" {
  source      = "./modules/mdn-uploader"
  name        = "mdn-uploader"
  environment = "prod"

  iam_policies = [
    "${module.media-bucket-prod.bucket_iam_policy}",
    "${module.mdn_cdn_prod.cdn-media-iam-policy}",
  ]

  eks_worker_role_arn = [
    "${data.terraform_remote_state.kops-us-west-2.nodes_role_arn}",
    "${data.terraform_remote_state.kops-eu-central-1.nodes_role_arn}",
    "${data.terraform_remote_state.eks-us-west-2.developer_portal_worker_iam_role_arn}",
    "${data.terraform_remote_state.eks-us-west-2.mdn_apps_a_worker_iam_role_arn}",
  ]
}
