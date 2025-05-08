variable "bucket_name" {
  type = string
}

variable "repo_endpoint" {
  type = string
}

variable "repos" {
  description = "Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo is located. `salt_versions` is the list of salt versions for which repo definitions will be generated. `yum_prefix` is the S3 key prefix for the yum repo definition files."
  type = list(object({
    repo_prefix   = string
    salt_versions = list(string)
    yum_prefix    = string

    repo_gpgkey_filename = optional(string, "SaltProjectKey.gpg.pub")
  }))
}
