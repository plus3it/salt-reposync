terraform {
  required_version = ">= 0.12"
}

module "main" {
  source = "../.."

  bucket_name   = local.bucket_name
  repo_endpoint = local.repo_endpoint
  repos = [
    {
      yum_prefix       = local.yum_prefix
      salt_s3_endpoint = local.salt_s3_endpoint
      salt_versions    = local.salt_versions
      repo_prefix      = local.repo_prefix
    },
    {
      repo_prefix      = local.repo_prefix_archive
      salt_s3_endpoint = local.salt_s3_endpoint_archive
      salt_versions    = local.salt_versions_archive
      yum_prefix       = local.yum_prefix
    },
  ]
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
  force_destroy = true
}

locals {
  bucket_name              = aws_s3_bucket.this.id
  repo_endpoint            = "https://${aws_s3_bucket.this.bucket_regional_domain_name}"
  repo_prefix              = "repo/main/"
  repo_prefix_archive      = "repo/archive/"
  salt_s3_endpoint         = "https://s3.repo.saltstack.com"
  salt_s3_endpoint_archive = "https://s3.archive.repo.saltstack.com"
  yum_prefix               = "defs/"

  salt_versions = [
    "3002",
  ]

  salt_versions_archive = [
    "2019.2.8",
  ]
}
