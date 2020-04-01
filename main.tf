module "sync_repo" {
  source = "./modules/repo"

  bucket_name         = var.bucket_name
  salt_version        = var.salt_version
  extra_salt_versions = var.extra_salt_versions
  repo_prefix         = var.repo_prefix
  salt_s3_endpoint    = var.salt_s3_endpoint
}

module "yum_defs" {
  source = "./modules/defs"

  bucket_name         = var.bucket_name
  salt_version        = var.salt_version
  extra_salt_versions = var.extra_salt_versions
  repo_endpoint       = var.repo_endpoint
  repo_prefix         = var.repo_prefix
  yum_prefix          = var.yum_prefix
}
