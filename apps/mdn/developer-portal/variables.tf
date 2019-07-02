variable "region" {
  default = "us-west-2"
}

variable "rds" {
  default = {
    user.stage     = "root"
    user.prod      = "root"
    password.stage = ""
    password.prod  = ""
  }
}
