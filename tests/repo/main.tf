terraform {
  required_version = ">= 0.12"
}

module "repo" {
  source = "../../modules/repo"

  bucket_name = local.bucket_name
  repos = [
    {
      salt_s3_endpoint = local.salt_s3_endpoint
      salt_versions    = local.salt_versions
      repo_prefix      = local.repo_prefix
    },
    {
      salt_s3_endpoint = local.salt_s3_endpoint_archive
      salt_versions    = local.salt_versions_archive
      repo_prefix      = local.repo_prefix_archive
    },
  ]
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
  force_destroy = true
}

locals {
  bucket_name              = aws_s3_bucket.this.id
  repo_prefix              = "repo/main/"
  repo_prefix_archive      = "repo/archive/"
  salt_s3_endpoint         = "https://s3.repo.saltstack.com"
  salt_s3_endpoint_archive = "https://s3.archive.repo.saltstack.com"

  salt_versions = [
    "3000.3",
    "2019.2.5",
  ]

  salt_versions_archive = [
    "2018.3.4",
  ]
}
