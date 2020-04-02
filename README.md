# salt-reposync
Pull salt packages for specific salt versions from an s3-hosted yum repo and
push them to S3.

## Usage

```
terraform init
terraform plan -var bucket_name=<BUCKET> -var salt_versions='["SALT_VERSION"]' -out tfplan
terraform apply -var bucket_name=<BUCKET> -var salt_versions='["SALT_VERSION"]' tfplan
```

## Prerequisites

1.  An AWS credential with get/put permissions to the S3 bucket must be pre-
    configured. Any method supported by the `aws` CLI may be used to configure
    the credential.
2.  `rclone` must be installed and available and in the PATH.

## Submodules

*   `repo` - Uses `rclone` to create a copy of the salt yum repo for the salt
    versions specified by `var.salt_versions`.

*   `defs` - Creates yum repo definition files for all `var.salt_versions` in 
    the S3 bucket specified by `var.bucket_name`.

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | S3 bucket where salt repo will be mirrored | `string` | n/a | yes |
| repo\_endpoint | HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions | `string` | n/a | yes |
| repo\_prefix | S3 key prefix where the repos will be mirrored | `string` | `""` | no |
| salt\_s3\_endpoint | S3 endpoint for the upstream salt repo | `string` | `"https://s3.repo.saltstack.com"` | no |
| salt\_versions | List of salt versions to mirror; will also generate version-specific yum .repo definition files | `list(string)` | `[]` | no |
| yum\_prefix | S3 key where the yum repo definitions will be placed | `string` | `""` | no |

## Outputs

No output.

<!-- END TFDOCS -->
