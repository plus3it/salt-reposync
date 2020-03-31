variable "bucket_name" {
  type = string
}

variable "salt_version" {
  type = string
}

variable "extra_salt_versions" {
  type    = list(string)
  default = []
}

variable "repo_endpoint" {
  type = string
}

variable "repo_prefix" {
  type    = string
  default = ""
}

variable "yum_prefix" {
  type    = string
  default = ""
}

variable "cache_dir" {
  type    = string
  default = ".filecache"
}
