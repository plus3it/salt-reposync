<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | n/a | `string` | n/a | yes |
| repos | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror. | <pre>list(object({<br>    repo_prefix      = string<br>    salt_s3_endpoint = string<br>    salt_versions    = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

No output.

<!-- END TFDOCS -->
