terraform {
  required_version = ">= 0.12"
}

module "repo" {
  source = "../../modules/repo"

  bucket_name = local.bucket_name
  repos = [
    {
      # Test using cloudfront endpoint for main repo
      salt_s3_bucket   = local.salt_s3_bucket
      salt_s3_endpoint = local.salt_s3_endpoint
      salt_versions    = local.salt_versions
      repo_prefix      = local.repo_prefix
    },
    {
      # Test using cloudfront endpoint for archive repo
      salt_s3_bucket   = local.salt_s3_bucket
      salt_s3_endpoint = local.salt_s3_endpoint_archive
      salt_versions    = local.salt_versions_archive
      repo_prefix      = local.repo_prefix_archive
    },
    {
      # Test using the underlying archive bucket directly, instead of cloudfront
      salt_s3_bucket   = "archive-repo-saltstack-com"
      salt_s3_endpoint = "s3.us-west-2.amazonaws.com"
      salt_versions    = local.salt_versions_archive
      repo_prefix      = "repo/underlying_bucket/"
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
  salt_s3_bucket           = "s3"
  salt_s3_endpoint         = "https://s3.repo.saltproject.io"
  salt_s3_endpoint_archive = "https://s3.archive.repo.saltproject.io"

  salt_versions = [
    "3005.1-4",
    "3005.1",
  ]

  salt_versions_archive = [
    "2019.2.8",
  ]
}
