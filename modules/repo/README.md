<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_repos"></a> [repos](#input\_repos) | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_bucket` is the name of s3 bucket; typically "s3" when using a cloudfront endpoint. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror. | <pre>list(object({<br/>    repo_prefix   = string<br/>    salt_versions = list(string)<br/><br/>    repo_type            = optional(string, "s3")<br/>    repo_gpgkey_filename = optional(string, "SaltProjectKey.gpg.pub")<br/><br/>    salt_s3_bucket   = optional(string)<br/>    salt_s3_endpoint = optional(string)<br/><br/>    salt_gpgkey_url = optional(string)<br/>    salt_webdav_url = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
