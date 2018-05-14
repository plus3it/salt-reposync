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

variable "yum_prefix" {
  type    = "string"
  default = ""
}

variable "s3_endpoint" {
  type    = "string"
  default = "https://s3.amazonaws.com"
}

variable "cache_dir" {
  type    = "string"
  default = ".filecache"
}
