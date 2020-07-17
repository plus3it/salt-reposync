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
| repos | n/a | <pre>list(object({<br>    repo_prefix      = string<br>    salt_s3_endpoint = string<br>    salt_versions    = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

No output.

<!-- END TFDOCS -->
