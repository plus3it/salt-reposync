variable "bucket_name" {
  type        = string
  description = "S3 bucket where salt repo will be mirrored"
}

variable "salt_version" {
  type        = string
  description = "Salt version that will be mirrored - this will also be the version used in the \"default\" yum repo definition file"
}

variable "extra_salt_versions" {
  type        = list(string)
  description = "List of additional salt versions to mirror - these will be in version-specific yum repo definition files"
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
