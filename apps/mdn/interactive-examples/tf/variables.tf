variable "region" {
  default = "us-west-2"
}

variable "interactive-example-bucket" {
  default = "mdninteractive"
}

variable "hosted-zone-id-defs" {
  # See: https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_website_region_endpoints
  type = map(string)

  default = {
    us-east-1 = "Z3AQBSTGFYJSTF"
    us-west-2 = "Z3BJ6K6RIION7M"
  }
}

variable "acm_certificate_arn" {
}

variable "origin_id" {
  default = "MDNInteractive"
}

variable "cdn_aliases" {
  type = list(string)
}
