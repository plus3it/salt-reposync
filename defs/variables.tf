variable "bucket_name" {}

variable "salt_version" {}

variable "extra_salt_versions" {
  default = []
}

variable "repo_prefix" {
  default = ""
}

variable "yum_prefix" {
  default = ""
}

variable "s3_endpoint" {
  default = "https://s3.amazonaws.com"
}

variable "cache_dir" {
  default = ".filecache"
}
