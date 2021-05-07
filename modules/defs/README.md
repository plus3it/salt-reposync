<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_repo_endpoint"></a> [repo\_endpoint](#input\_repo\_endpoint) | n/a | `string` | n/a | yes |
| <a name="input_repos"></a> [repos](#input\_repos) | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo is located. `salt_versions` is the list of salt versions for which repo definitions will be generated. `yum_prefix` is the S3 key prefix for the yum repo definition files. | <pre>list(object({<br>    repo_prefix   = string<br>    salt_versions = list(string)<br>    yum_prefix    = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
