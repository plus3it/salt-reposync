terraform {
  required_version = ">= 0.12"
}

module "repo" {
  source = "../../modules/repo"

  bucket_name   = local.bucket_name
  salt_versions = local.salt_versions
  repo_prefix   = local.repo_prefix
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

  repo_prefix = "repo/"
}
