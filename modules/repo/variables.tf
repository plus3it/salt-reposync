variable "bucket_name" {
  type = string
}

variable "repos" {
  type = list(object({
    repo_prefix      = string
    salt_s3_endpoint = string
    salt_versions    = list(string)
  }))
  default = []
}
