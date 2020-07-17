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
| repos | n/a | <pre>list(object({<br>    repo_prefix   = string<br>    salt_versions = list(string)<br>    yum_prefix    = string<br>  }))</pre> | `[]` | no |

## Outputs

No output.

<!-- END TFDOCS -->
