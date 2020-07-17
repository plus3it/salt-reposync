variable "bucket_name" {
  type = string
}

variable "repo_endpoint" {
  type = string
}

variable "repos" {
  type = list(object({
    repo_prefix   = string
    salt_versions = list(string)
    yum_prefix    = string
  }))
  default = []
}
