variable "bucket_name" {}

variable "salt_version" {}

variable "extra_salt_versions" {
  default = []
}

variable "repo_prefix" {
  default = ""
}

variable "salt_rsync_url" {
  default = "rsync://repo.saltstack.com/saltstack_pkgrepo_rhel"
}

variable "cache_dir" {
  default = ".filecache"
}
