module "sync_repo" {
  source = "./modules/repo"

  bucket_name         = var.bucket_name
  salt_version        = var.salt_version
  extra_salt_versions = var.extra_salt_versions
  repo_prefix         = var.repo_prefix
  salt_rsync_url      = var.salt_rsync_url
  cache_dir           = "${var.cache_dir}/repo"
}

module "yum_defs" {
  source = "./modules/defs"

  bucket_name         = var.bucket_name
  salt_version        = var.salt_version
  extra_salt_versions = var.extra_salt_versions
  repo_endpoint       = var.repo_endpoint
  repo_prefix         = var.repo_prefix
  yum_prefix          = var.yum_prefix
  cache_dir           = "${var.cache_dir}/defs"
}
