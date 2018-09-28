module "sync_repo" {
  source = "./repo"

  bucket_name         = "${var.bucket_name}"
  salt_version        = "${var.salt_version}"
  extra_salt_versions = "${var.extra_salt_versions}"
  repo_prefix         = "${var.repo_prefix}"
  salt_rsync_url      = "${var.salt_rsync_url}"
  cache_dir           = "${var.cache_dir}/repo"
}

module "yum_defs" {
  source = "./defs"

  bucket_name         = "${var.bucket_name}"
  salt_version        = "${var.salt_version}"
  extra_salt_versions = "${var.extra_salt_versions}"
  repo_prefix         = "${var.repo_prefix}"
  yum_prefix          = "${var.yum_prefix}"
  s3_endpoint         = "${var.s3_endpoint}"
  cache_dir           = "${var.cache_dir}/defs"
}