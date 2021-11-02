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
2.  `rclone` >= 1.57.0 must be installed and available and in the PATH.

## Testing

At the moment, testing is manual:

```
make rclone/install

# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

## Submodules

*   `repo` - Uses `rclone` to create a copy of the salt yum repo for the salt
    versions specified by `var.salt_versions`.

*   `defs` - Creates yum repo definition files for all `var.salt_versions` in 
    the S3 bucket specified by `var.bucket_name`.

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket where salt repo will be mirrored | `string` | n/a | yes |
| <a name="input_repo_endpoint"></a> [repo\_endpoint](#input\_repo\_endpoint) | HTTP/S endpoint URL that hosts the yum repos; used with the baseurl in the yum .repo definitions | `string` | n/a | yes |
| <a name="input_repos"></a> [repos](#input\_repos) | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror. `yum_prefix` is the S3 key prefix for the yum repo definition files. | <pre>list(object({<br>    repo_prefix      = string<br>    salt_s3_endpoint = string<br>    salt_versions    = list(string)<br>    yum_prefix       = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
