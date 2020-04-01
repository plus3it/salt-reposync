terraform {
  required_version = ">= 0.12"
}

module "main" {
  source = "../.."

  bucket_name   = local.bucket_name
  salt_versions = local.salt_versions
  repo_endpoint = local.repo_endpoint
  repo_prefix   = local.repo_prefix
  yum_prefix    = local.yum_prefix
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
  force_destroy = true
}

locals {
  bucket_name = aws_s3_bucket.this.id

  salt_versions = [
    "3000",
    "2019.2.3",
    "2018.3.4",
  ]

  repo_endpoint = "https://${aws_s3_bucket.this.bucket_regional_domain_name}"
  repo_prefix   = "repo/"
  yum_prefix    = "defs/"
}
