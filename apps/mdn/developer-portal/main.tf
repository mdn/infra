provider "aws" {
  version = "~> 2"
  region  = var.region
}

module "backup_bucket" {
  source         = "./modules/backup-bucket"
  bucket_name    = "developer-portal-backups"
  eks_cluster_id = data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_cluster_name
}

module "mail_stage" {
  source       = "./modules/mail"
  service_name = "dev-portal"
  environment  = "stage"
}

## dev resources
module "db_dev" {
  source         = "./modules/db"
  environment    = "dev"
  vpc_id         = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  identifier     = "developer-portal"
  instance_class = "db.t3.micro"
  db_name        = "developer_portal"
  db_user        = local.rds["user"]
  db_password    = var.rds["dev"]["password"]
}

module "bucket_dev" {
  source              = "./modules/bucket"
  environment         = "dev"
  create_user         = true
  bucket_name         = "developer-portal"
  eks_worker_role_arn = data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_iam_role_arn
  distribution_id     = module.cdn_dev.cloudfront_id
}

module "cdn_dev" {
  source          = "./modules/cdn"
  environment     = "dev"
  cdn_aliases     = ["developer-portal.dev.mdn.mozit.cloud", "developer-portal-cdn.dev.mdn.mozit.cloud"]
  origin_bucket   = module.bucket_dev.bucket_id
  logging_bucket  = module.bucket_dev.logging_bucket_id
  certificate_arn = data.aws_acm_certificate.developer-portal-cdn-dev.arn
}

module "redis_dev" {
  source          = "./modules/redis"
  redis_id        = "developer-portal"
  environment     = "dev"
  redis_nodes     = "2"
  redis_node_type = "cache.t3.micro"
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  subnets         = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  security_groups = [
    data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_security_group_id,
  ]
}

## Stage resources
module "db_stage" {
  source         = "./modules/db"
  environment    = "stage"
  vpc_id         = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  identifier     = "developer-portal"
  instance_class = "db.t3.medium"
  db_name        = "developer_portal"
  db_user        = local.rds["user"]
  db_password    = var.rds["stage"]["password"]
}

module "bucket_stage" {
  source              = "./modules/bucket"
  environment         = "stage"
  create_user         = true
  bucket_name         = "developer-portal"
  eks_worker_role_arn = data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_iam_role_arn
  distribution_id     = module.cdn_stage.cloudfront_id
}

module "cdn_stage" {
  source          = "./modules/cdn"
  environment     = "stage"
  cdn_aliases     = ["developer-portal.stage.mdn.mozit.cloud", "developer-portal-cdn.stage.mdn.mozit.cloud"]
  origin_bucket   = module.bucket_stage.bucket_id
  logging_bucket  = module.bucket_stage.logging_bucket_id
  certificate_arn = data.aws_acm_certificate.developer-portal-cdn-stage.arn
}

module "redis_stage" {
  source          = "./modules/redis"
  redis_id        = "developer-portal"
  environment     = "stage"
  redis_nodes     = "3"
  redis_node_type = "cache.t3.micro"
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  subnets         = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  security_groups = [
    data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_security_group_id,
  ]
}

## Prod resources
module "db_prod" {
  source         = "./modules/db"
  environment    = "prod"
  vpc_id         = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  identifier     = "developer-portal"
  instance_class = "db.t3.medium"
  db_name        = "developer_portal"
  db_user        = local.rds["user"]
  db_password    = var.rds["prod"]["password"]
}

module "bucket_prod" {
  source              = "./modules/bucket"
  environment         = "prod"
  create_user         = true
  bucket_name         = "developer-portal"
  eks_worker_role_arn = data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_iam_role_arn
  distribution_id     = module.cdn_prod.cloudfront_id
}

module "cdn_prod" {
  source          = "./modules/cdn"
  environment     = "prod"
  cdn_aliases     = ["developer-portal.prod.mdn.mozit.cloud", "developer-portal-cdn.prod.mdn.mozit.cloud", "developer.mozilla.com"]
  origin_bucket   = module.bucket_prod.bucket_id
  logging_bucket  = module.bucket_prod.logging_bucket_id
  certificate_arn = data.aws_acm_certificate.developer-portal-cdn-prod.arn
}

module "redis_prod" {
  source          = "./modules/redis"
  redis_id        = "developer-portal"
  environment     = "prod"
  redis_nodes     = "3"
  redis_node_type = "cache.t3.small"
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  subnets         = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  security_groups = [
    data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_worker_security_group_id,
  ]
}

