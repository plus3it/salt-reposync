variable "bucket_name" {
  type = "string"
}

variable "salt_version" {
  type = "string"
}

variable "extra_salt_versions" {
  type    = "list"
  default = []
}

variable "repo_prefix" {
  type    = "string"
  default = ""
}

variable "salt_rsync_url" {
  type    = "string"
  default = "rsync://rsync.repo.saltstack.com/saltstack_pkgrepo_rhel"
}

variable "salt_python3_rsync_url" {
  type    = "string"
  default = "rsync://rsync.repo.saltstack.com/saltstack_pkgrepo_rhel_python3"
}

variable "cache_dir" {
  type    = "string"
  default = ".filecache"
}
