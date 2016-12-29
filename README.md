# salt-reposync
Pull salt packages for a specific salt version from an rsync yum repo and push
them to S3.

## Usage

```
<PARAM>=<arg> make <target>
```

See the section **Targets** for a description of the supported make targets.

See the section **Environment Variables** for a description of the supported env
parameters.

## Prerequisites

1.  The `aws` CLI must be installed and available in the PATH.
2.  An AWS credential with get/put permissions to the S3 bucket must be pre-
configured. Any method supported by the `aws` CLI may be used to configure the
credential.

## Example

```
git clone https://github.com/plus3it/salt-reposync.git && cd salt-reposync

REPOSYNC_SALT_VERSION="2016.3.4" \
REPOSYNC_HTTP_URL="https://s3.amazonaws.com/examplebucket/linux/saltstack/salt" \
make sync.s3
```

The above example will use rsync to download all packages required for salt
version 2016.3.4 from the upstream salt yum repo, construct yum repo
definitions based on the `REPOSYNC_HTTP_URL` parameter, and push the repos and
the repo definitions to the S3 bucket named "_examplebucket_". The repos will
be located in the S3 bucket at the path "_linux/saltstack/salt_".

## Targets

-   `help`
    -   Show this help message
-   `deps`
    -   Install rpm dependencies (E.g. `zip`)
-   `sync.s3`
    -   Run `make deps` and then download salt repos, create yum repos
    definitions, and push the repos to s3. This target supports setting script
    parameters via environment variables. Will return an error if any of the
    required environment variables are unset. See the help section "Environment
    Variables".

## Environment Variables

-   `REPOSYNC_HTTP_URL`
    -   **(Required)** URL where the salt repos will be re-hosted
-   `REPOSYNC_SALT_VERSION`
    -   **(Required)** Salt version to download
-   `REPOSYNC_SALT_RSYNC_URL`
    -   **(Optional)** Source rsync url to the salt file list. Defaults to
    "`rsync://repo.saltstack.com/saltstack_pkgrepo_rhel`".
-   `REPOSYNC_STAGING_DIR`
    -   **(Optional)** Target directory for rsync. Defaults to
    "`/tmp/salt-reposync`".

## CloudFormation

This project also provides a CloudFormation template that can be used to
execute salt-reposync. The template requires an IAM instance role with the
necessary permissions to the S3 bucket, as described in the **Prerequisites**
section.

In addition, the AMI must have the `aws` CLI utility pre-installed and in the
PATH of the root user (the context in which userdata executes). The Amazon
Linux AMIs all meet this requirement, but any AMI configured similarly may also
be used.

-   `salt-reposync.template.json`
