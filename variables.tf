variable "bucket_name" {
  type        = string
  description = "S3 bucket where salt repo will be mirrored"
}

variable "repo_endpoint" {
  type        = string
  description = "HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions"
}

variable "repos" {
  type = list(object({
    repo_prefix      = string
    salt_s3_endpoint = string
    salt_versions    = list(string)
    yum_prefix       = string
  }))
  default = []
}
