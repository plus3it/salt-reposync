variable "bucket_name" {
  type        = string
  description = "S3 bucket where salt repo will be mirrored"
}

variable "salt_versions" {
  type        = list(string)
  description = "List of salt versions to mirror; will also generate version-specific yum .repo definition files"
  default     = []
}

variable "repo_endpoint" {
  type        = string
  description = "HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions"
}

variable "repo_prefix" {
  type        = string
  description = "S3 key prefix where the repos will be mirrored"
  default     = ""
}

variable "yum_prefix" {
  type        = string
  description = "S3 key where the yum repo definitions will be placed"
  default     = ""
}

variable "salt_s3_endpoint" {
  type        = string
  description = "S3 endpoint for the upstream salt repo"
  default     = "https://s3.repo.saltstack.com"
}
