variable "bucket_name" {
  type = string
}

variable "salt_versions" {
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
