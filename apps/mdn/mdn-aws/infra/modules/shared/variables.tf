variable "region" {
  default = "us-west-2"
}

variable enabled {}

# This variable is no longer used but we have to keep
# it around to avoid the has to regenerate
variable db_storage_bucket_name {
  default = "mdn-db-storage"
}

variable elb_logs_bucket_name {
  default = "mdn-elb-logs"
}

variable downloads_bucket_name {
  default = "mdn-downloads"
}

variable shared_backup_bucket_name {
  default = "mdn-efs-backup"
}

variable "hosted-zone-id-defs" {
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_website_region_endpoints
  type = "map"

  default = {
    us-east-1 = "Z3AQBSTGFYJSTF"
    us-west-2 = "Z3BJ6K6RIION7M"
  }
}
