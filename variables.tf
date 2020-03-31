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
  description = "S3 key where the repos will be mirrored"
  default     = ""
}

variable "yum_prefix" {
  type        = string
  description = "S3 key where the yum repo definitions will be placed"
  default     = ""
}

variable "salt_rsync_url" {
  type        = string
  description = "rsync URL to the upstream yum repo"
  default     = "rsync://rsync.repo.saltstack.com/saltstack_pkgrepo_rhel"
}

variable "cache_dir" {
  type        = string
  description = "Local directory used to cache files"
  default     = ".filecache"
}
