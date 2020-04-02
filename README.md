# salt-reposync
Pull salt packages for a specific salt version from an rsync yum repo and push
them to S3.

## Usage

```
terraform init
terraform plan -var bucket_name=<BUCKET> -var salt_version="SALT_VERSION" -out tfplan
terraform apply -var bucket_name=<BUCKET> -var salt_version="SALT_VERSION" tfplan
```

## Prerequisites

1.  The `aws` CLI must be installed and available in the PATH.
2.  An AWS credential with get/put permissions to the S3 bucket must be pre-
    configured. Any method supported by the `aws` CLI may be used to configure
    the credential.
3.  `rsync` must be installed and available and in the PATH.

## Submodules

*   `repo` - Uses `rsync` to create a local copy of the salt yum repo for the
    salt versions specified by `var.salt_version` and `var.extra_salt_versions`.
    The `aws` utility is used to sync the local copy to the S3 bucket specified
    by `var.bucket_name`.

*   `defs` - Templates the yum repo definition files and uses the `aws` utility
    to sync them to the S3 bucket specified by `var.bucket_name`.

<!-- BEGIN TFDOCS -->
## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bucket\_name | S3 bucket where salt repo will be mirrored | `string` | n/a | yes |
| repo\_endpoint | HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions | `string` | n/a | yes |
| repo\_prefix | S3 key prefix where the repos will be mirrored | `string` | `""` | no |
| salt\_s3\_endpoint | S3 endpoint for the upstream salt repo | `string` | `"https://s3.repo.saltstack.com"` | no |
| salt\_versions | List of salt versions to mirror; will also generate version-specific yum .repo definition files | `list(string)` | `[]` | no |
| yum\_prefix | S3 key where the yum repo definitions will be placed | `string` | `""` | no |

## Outputs

No output.

<!-- END TFDOCS -->
