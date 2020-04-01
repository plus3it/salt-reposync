terraform {
  required_version = ">= 0.12"
}

module "repo" {
  source = "../../modules/repo"

  bucket_name         = local.bucket_name
  salt_version        = local.salt_version
  extra_salt_versions = local.extra_salt_versions
  repo_prefix         = local.repo_prefix
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
  force_destroy = true
}

locals {
  bucket_name  = aws_s3_bucket.this.id
  salt_version = "3000"

  extra_salt_versions = [
    "2019.2.3",
    "2018.3.4",
  ]

  repo_prefix = "repo/"
}
