provider "aws" {
  region = var.region
}

module "mdn_shared" {
  source  = "./modules/shared"
  enabled = lookup(var.features, "shared-infra")
  region  = var.region
}

module "rds-backups" {
  source         = "./modules/rds-backups"
  region         = "us-west-2"
  eks_cluster_id = data.terraform_remote_state.eks-eu-central-1.outputs.mdn_cluster_name
}

module "security" {
  source           = "./modules/security"
  eks_cluster_id   = data.terraform_remote_state.eks-us-west-2.outputs.mdn_cluster_name
  us-west-2-vpc-id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

module "mdn_cdn" {
  source      = "./modules/mdn-cdn"
  enabled     = lookup(var.features, "cdn")
  region      = var.region
  environment = "stage"

  # attachment CDN
  cloudfront_attachments_enabled           = "0" # Disable for stage
  acm_attachments_cert_arn                 = data.aws_acm_certificate.attachment-cdn-cert.arn
  cloudfront_attachments_distribution_name = var.cloudfront_attachments["distribution_name"]
  cloudfront_attachments_aliases           = split(",", var.cloudfront_attachments["aliases.stage"])
  cloudfront_attachments_domain_name       = var.cloudfront_attachments["domain.stage"]

  # media CDN
  cloudfront_media_enabled = var.cloudfront_media["enabled"]
  acm_media_cert_arn       = data.aws_acm_certificate.stage-media-cdn-cert.arn
  cloudfront_media_aliases = split(",", var.cloudfront_media["aliases.stage"])
  cloudfront_media_bucket  = module.media-bucket-stage.bucket_name
}

module "mdn_cdn_prod" {
  source      = "./modules/mdn-cdn"
  enabled     = lookup(var.features, "cdn")
  region      = var.region
  environment = "prod"

  # attachment CDN
  cloudfront_attachments_enabled           = var.cloudfront_attachments["enabled"]
  acm_attachments_cert_arn                 = data.aws_acm_certificate.attachment-cdn-cert.arn
  cloudfront_attachments_distribution_name = var.cloudfront_attachments["distribution_name"]
  cloudfront_attachments_aliases           = split(",", var.cloudfront_attachments["aliases.prod"])
  cloudfront_attachments_domain_name       = var.cloudfront_attachments["domain.prod"]

  # media CDN
  cloudfront_media_enabled = var.cloudfront_media["enabled"]
  acm_media_cert_arn       = data.aws_acm_certificate.prod-media-cdn-cert.arn
  cloudfront_media_aliases = split(",", var.cloudfront_media["aliases.prod"])
  cloudfront_media_bucket  = module.media-bucket-prod.bucket_name
}

# SE-2442 create updates infrastructure
module "mdn_updates_stage" {
  source       = "./modules/mdn-updates"
  region       = var.region
  environment  = "stage"
  acm_cert_arn = data.aws_acm_certificate.updates_stage_mdn_mozit_cloud.arn
}

# TODO: Split this up into multiple files other stuff can get messy quick
# Multi region resources

module "redis-stage-us-west-2" {
  source          = "./modules/multi_region/redis"
  enabled         = lookup(var.features, "redis")
  environment     = "stage"
  region          = "us-west-2"
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  azs             = ["us-west-2c", "us-west-2b", "us-west-2a"]
  redis_name      = "mdn-stage"
  redis_node_size = "cache.t3.medium"
  redis_num_nodes = "3"
}

module "redis-prod-us-west-2" {
  source          = "./modules/multi_region/redis"
  enabled         = lookup(var.features, "redis")
  environment     = "prod"
  region          = "us-west-2"
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  redis_name      = "mdn-prod"
  redis_node_size = "cache.m5.large"
  redis_num_nodes = "3"
}

module "redis-prod-eu-central-1" {
  source          = "./modules/multi_region/redis"
  enabled         = lookup(var.features, "redis")
  environment     = "prod"
  region          = "eu-central-1"
  vpc_id          = data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id
  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  redis_name      = "mdn-prod"
  redis_node_size = "cache.m5.large"
  redis_num_nodes = "3"
}

module "mysql-us-west-2" {
  source      = "./modules/multi_region/rds"
  enabled     = lookup(var.features, "rds")
  environment = "stage"
  region      = "us-west-2"

  # postgres database
  postgres_db_name               = local.rds["stage"]["db_name"]
  postgres_username              = local.rds["stage"]["postgres_username"]
  postgres_password              = var.rds["stage"]["password"]
  postgres_identifier            = "mdn-stage-postgres"
  postgres_engine_version        = local.rds["stage"]["postgres_engine_version"]
  postgres_instance_class        = local.rds["stage"]["instance_class"]
  postgres_backup_retention_days = local.rds["stage"]["backup_retention_days"]
  postgres_storage_gb            = local.rds["stage"]["postgres_storage_gb"]
  postgres_storage_type          = local.rds["stage"]["storage_type"]

  # shared
  rds_security_group_name = "mdn_rds_sg_stage"
  vpc_id                  = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  monitoring_interval     = "60"
}

module "mysql-us-west-2-prod" {
  source      = "./modules/multi_region/rds"
  enabled     = var.features["rds"]
  environment = "prod"
  region      = "us-west-2"

  # postgres database
  postgres_db_name               = local.rds["prod"]["db_name"]
  postgres_username              = local.rds["prod"]["postgres_username"]
  postgres_password              = var.rds["prod"]["password"]
  postgres_identifier            = "mdn-prod-postgres"
  postgres_engine_version        = local.rds["prod"]["postgres_engine_version"]
  postgres_instance_class        = local.rds["prod"]["instance_class"]
  postgres_backup_retention_days = 30
  postgres_storage_gb            = local.rds["prod"]["storage_gb"]

  #shared
  rds_security_group_name = "mdn_rds_sg_prod"
  vpc_id                  = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  monitoring_interval     = "60"
}

# Replica set
module "mysql-eu-central-1-replica-prod" {
  source                     = "./modules/multi_region/rds-replica"
  environment                = "prod"
  region                     = "eu-central-1"
  postgres_replica_source_db = module.mysql-us-west-2-prod.postgres_rds_arn
  vpc_id                     = data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id
  kms_key_id                 = lookup(var.rds, "key_id.eu-central-1") # Less than ideal this key is copied from the console
  instance_class             = local.rds["prod"]["instance_class"]
  monitoring_interval        = "60"
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
    module.media-bucket-stage.bucket_iam_policy,
    #module.mdn_cdn.cdn-media-iam-policy,
  ]
}

module "upload-user-prod" {
  source      = "./modules/mdn-uploader"
  name        = "mdn-uploader"
  environment = "prod"

  iam_policies = [
    module.media-bucket-prod.bucket_iam_policy,
    #module.mdn_cdn_prod.cdn-media-iam-policy,
  ]

}

# Create role for media sync
module "media-sync-roles" {
  source                  = "./modules/media-sync"
  cluster_oidc_issuer_url = data.terraform_remote_state.eks-us-west-2.outputs.mdn_cluster_oidc_issuer_url
  stage_bucket            = module.media-bucket-stage.bucket_name
  prod_bucket             = module.media-bucket-prod.bucket_name
}
