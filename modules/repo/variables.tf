variable "bucket_name" {
  type = string
}

variable "salt_versions" {
  type    = list(string)
  default = []
}

variable "repo_prefix" {
  type    = string
  default = "/"
}

variable "salt_s3_endpoint" {
  type    = string
  default = "https://s3.repo.saltstack.com"
}
