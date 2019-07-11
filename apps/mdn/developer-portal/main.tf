provider "aws" {
  region = "${var.region}"
}

module "db_stage" {
  source         = "./modules/db"
  environment    = "stage"
  vpc_id         = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  identifier     = "developer-portal"
  instance_class = "db.t2.large"
  db_name        = "developer_portal"
  db_user        = "${lookup(var.rds, "user.stage")}"
  db_password    = "${lookup(var.rds, "password.stage")}"
}

module "bucket_stage" {
  source              = "./modules/bucket"
  environment         = "stage"
  bucket_name         = "developer-portal"
  eks_worker_role_arn = "${data.terraform_remote_state.eks-us-west-2.developer_portal_worker_iam_role_arn}"
}
