terraform {
  required_version = ">= 0.12"
}

module "defs" {
  source = "../../modules/defs"

  bucket_name         = local.bucket_name
  salt_version        = local.salt_version
  extra_salt_versions = local.extra_salt_versions
  repo_endpoint       = local.repo_endpoint
  repo_prefix         = local.repo_prefix
  yum_prefix          = local.yum_prefix
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
}

locals {
  bucket_name  = aws_s3_bucket.this.id
  salt_version = "3000"

  extra_salt_versions = [
    "2019.2.3",
    "2018.3.4",
  ]

  repo_endpoint = "https://${aws_s3_bucket.this.bucket_regional_domain_name}"
  repo_prefix   = "repo/"
  yum_prefix    = "defs/"
}
