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
