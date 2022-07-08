variable "bucket_name" {
  type        = string
  description = "S3 bucket where salt repo will be mirrored"
}

variable "repo_endpoint" {
  type        = string
  description = "HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions"
}

variable "repos" {
  description = "Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_bucket` is the name of s3 bucket; typically \"s3\" when using a cloudfront endpoint. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror. `yum_prefix` is the S3 key prefix for the yum repo definition files."
  type = list(object({
    repo_prefix      = string
    salt_s3_bucket   = string
    salt_s3_endpoint = string
    salt_versions    = list(string)
    yum_prefix       = string
  }))
}
