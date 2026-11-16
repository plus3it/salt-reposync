# salt-reposync
Mirror salt packages for specific salt versions from an upstream yum repo to an
S3 bucket, and create yum repo definition files for those versions in the same
bucket.

## Usage

Set `bucket_name`, `repo_endpoint`, and `repos` in a `.tfvars` file. Each object
in `repos` selects one upstream repo and the salt versions to mirror from it.

```
terraform init
terraform plan -var-file=salt-reposync.tfvars -out tfplan
terraform apply tfplan
```

Example `salt-reposync.tfvars`:

```
bucket_name   = "my-salt-repo-bucket"
repo_endpoint = "https://repo.example.com"

repos = [
  {
    repo_type       = "webdav"
    salt_webdav_url = "https://packages.broadcom.com/artifactory/"
    salt_gpgkey_url = "https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public"
    salt_versions   = ["3006.9"]
    repo_prefix     = "repo/salt/"
    yum_prefix      = "yum/salt/"
  },
]
```

Each object in `repos` supports these settings:

*   `repo_type` - Either `s3` (the default) or `webdav`.
    *   For `s3`, set `salt_s3_bucket` and `salt_s3_endpoint` to the upstream
        S3 bucket and endpoint.
    *   For `webdav`, set `salt_webdav_url` to the upstream WebDAV URL. The
        module syncs the `saltproject-rpm/` path under that URL. Set
        `salt_gpgkey_url` to also copy the GPG key into the mirror.
*   `salt_versions` - The salt versions to mirror.
*   `repo_prefix` - The S3 key prefix where the repo is mirrored.
*   `yum_prefix` - The S3 key prefix for the yum repo definition files.
*   `repo_gpgkey_filename` - The file name of the GPG key. The default is
    `SaltProjectKey.gpg.pub`.

For `webdav` repos, `salt_gpgkey_url` is copied to
`<repo_prefix>/onedir/<repo_gpgkey_filename>`. The yum repo definition files use
that file as the `gpgkey`. The module does not copy a GPG key for `s3` repos.

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
    versions specified by `salt_versions` in each object of `var.repos`.

*   `defs` - Creates yum repo definition files for the `salt_versions` of each
    object in `var.repos`, in the S3 bucket specified by `var.bucket_name`.

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
| <a name="input_repos"></a> [repos](#input\_repos) | Schema list of repo objects. `repo_prefix` is the S3 key prefix where the repo will be mirrored. `salt_s3_bucket` is the name of s3 bucket; typically "s3" when using a cloudfront endpoint. `salt_s3_endpoint` is the upstream s3 endpoint hosting the repos. `salt_versions` is the list of salt versions to mirror. `yum_prefix` is the S3 key prefix for the yum repo definition files. | <pre>list(object({<br/>    repo_prefix   = string<br/>    salt_versions = list(string)<br/>    yum_prefix    = string<br/><br/>    repo_type            = optional(string, "s3")<br/>    repo_gpgkey_filename = optional(string, "SaltProjectKey.gpg.pub")<br/><br/>    salt_s3_bucket   = optional(string)<br/>    salt_s3_endpoint = optional(string)<br/><br/>    salt_gpgkey_url = optional(string)<br/>    salt_webdav_url = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
