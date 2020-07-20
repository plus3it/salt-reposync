<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | n/a | `string` | n/a | yes |
| repo\_endpoint | n/a | `string` | n/a | yes |
| repos | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo is located. `salt_versions` is the list of salt versions for which repo definitions will be generated. `yum_prefix` is the S3 key prefix for the yum repo definition files. | <pre>list(object({<br>    repo_prefix   = string<br>    salt_versions = list(string)<br>    yum_prefix    = string<br>  }))</pre> | n/a | yes |

## Outputs

No output.

<!-- END TFDOCS -->
