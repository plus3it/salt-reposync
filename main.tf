module "sync_repo" {
  source = "./modules/repo"

  bucket_name = var.bucket_name
  repos       = var.repos
}

module "yum_defs" {
  source = "./modules/defs"

  bucket_name   = var.bucket_name
  repo_endpoint = var.repo_endpoint
  repos         = var.repos
}
