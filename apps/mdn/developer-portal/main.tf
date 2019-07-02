provider "aws" {
  region = "${var.region}"
}

module "db_stage" {
  source         = "./modules/db"
  environment    = "stage"
  vpc_id         = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  identifier     = "developer-portal"
  instance_class = "db.t2.large"
  db_name        = "developer_insights"
  db_password    = "T7nzT7X3bgLVVVgxbbdHKrsHqCVp99fm"
  db_user        = "${lookup(var.rds, "user.stage")}"
  db_password    = "${lookup(var.rds, "password.stage")}"
}
