variable enabled {
  default = true
}

variable region {
  default = "us-west-2"
}

variable features {
  default = {
    shared-infra = 1
    cdn          = 1
    efs          = 1
    rds          = 1
    redis        = 1
  }
}

variable cloudfront_primary {
  default = {
    enabled           = "1"
    distribution_name = "mdn-primary-cdn"
    aliases.stage     = "beta.developer.allizom.org,developer-stage.mdn.mozit.cloud,developer.allizom.org"
    aliases.prod      = "beta.developer.mozilla.org,developer-prod.mdn.mozit.cloud,developer.mozilla.org"
    api_bucket.stage  = "mdn-api-stage"
    api_bucket.prod   = "mdn-api-prod"
    domain.stage      = "stage.mdn.mozit.cloud"
    domain.prod       = "prod.mdn.mozit.cloud"
  }
}

variable cloudfront_attachments {
  default = {
    enabled           = "1"
    distribution_name = "mdn-attachment-cdn"
    aliases.stage     = ""

    #FIXME: mdn.mozillademos.org is taken
    #aliases.prod      = "mdn.mozillademos.org,demos.mdn.mozit.cloud"
    aliases.prod = "demos.mdn.mozit.cloud,mdn.mozillademos.org"

    acm_arn.stage = ""
    acm_arn.prod  = "arn:aws:acm:us-west-2:178589013767:certificate/2f399635-126c-4e83-bf43-5ddbd0525719"
    domain.stage  = "stage.mdn.mozit.cloud"
    domain.prod   = "demos-origin.mdn.mozit.cloud"
  }
}

variable "cloudfront_wiki" {
  default = {
    enabled           = "1"
    distribution_name = "mdn-wiki-cdn"
    domain.stage      = "stage.mdn.mozit.cloud"
    domain.prod       = "prod.mdn.mozit.cloud"
    aliases.stage     = "wiki.developer.allizom.org"
    aliases.prod      = "wiki.developer.mozilla.org"
  }
}

variable redis {
  default = {
    node_size.stage = "cache.t2.small"
    node_size.prod  = "cache.m3.xlarge"
    num_nodes.stage = "3"
    num_nodes.prod  = "3"
  }
}

variable rds {
  default = {
    db_name.stage               = "developer_allizom_org"
    db_name.prod                = "developer_mozilla_org"
    username.stage              = "root"
    username.prod               = "root"
    password.stage              = ""
    password.prod               = ""
    engine_version.stage        = "5.6.41"
    engine_version.prod         = "5.6.41"
    instance_class.stage        = "db.t3.large"
    instance_class.prod         = "db.m5.xlarge"
    backup_retention_days.stage = "1"
    backup_retention_days.prod  = "7"
    storage_gb.stage            = "100"
    storage_gb.prod             = "200"
    storage_type                = "gp2"
  }
}

variable "kms" {
  default = {
    key_id.us-west-2 = ""
  }
}

variable "datadog_external_id" {}
