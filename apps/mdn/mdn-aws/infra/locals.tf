locals {

  rds_defaults_defaults = {
    username              = "root"
    engine_version        = "5.6.41"
    backup_retention_days = "1"
    storage_type          = "gp2"
    storage_gb            = "100"
  }

  rds_defaults = merge(
    local.rds_defaults_defaults,
    var.rds_defaults
  )

  # RDS Args for environment specific items
  rds_envs = {
    stage = {
      db_name               = "developer_allizom_org"
      password              = ""
      instance_class        = "db.t3.large"
      backup_retention_days = "1"
      storage_gb            = "100"
    },
    prod = {
      db_name               = "developer_mozilla_org"
      password              = ""
      instance_class        = "db.m5.xlarge"
      backup_retention_days = "7"
      storage_gb            = "200"
    }
  }

  rds = { for k, v in local.rds_envs : k => merge(local.rds_defaults, local.rds_envs[k]) }

  # TODO: convert the redis and cloudfront module to use a similar method
  # of grabbing variables
}
