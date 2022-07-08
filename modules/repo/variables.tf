variable "bucket_name" {
  type = string
}

variable "repos" {
  description = "Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_bucket` is the name of s3 bucket; typically \"s3\" when using a cloudfront endpoint. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror."
  type = list(object({
    repo_prefix      = string
    salt_s3_bucket   = string
    salt_s3_endpoint = string
    salt_versions    = list(string)
  }))
}
