locals {
  repos = [
    for repo in var.repos : {
      id                  = "${repo.salt_s3_endpoint}_${repo.repo_prefix}"
      repo_prefix_python2 = "${trim(repo.repo_prefix, "/")}/python2"
      repo_prefix_python3 = "${trim(repo.repo_prefix, "/")}/python3"
      salt_s3_endpoint    = repo.salt_s3_endpoint
      salt_versions       = formatlist("--filter '+ {amazon,redhat}/{latest,?}/**/archive/%s/**'", sort(repo.salt_versions))
    }
  ]

  rclone_base = [
    "RCLONE_CONFIG_SALT_TYPE=s3",
    "RCLONE_CONFIG_SALT_PROVIDER=Other",
    "RCLONE_CONFIG_SALT_ENV_AUTH=false",
    "RCLONE_CONFIG_SALT_ENDPOINT=%s", # %s is repo.salt_s3_endpoint
    "RCLONE_CONFIG_S3_TYPE=s3",
    "RCLONE_CONFIG_S3_ENV_AUTH=true",
    "rclone sync",
    "--delete-excluded --use-server-modtime --update --fast-list -v",
    "--filter '- **/{i386,i686,SRPMS}/**'",
    "%s", # %s is repo.salt_versions
    "--filter '- *'",
  ]

  rclone_python2 = concat(
    local.rclone_base,
    tolist([
      "salt:s3/yum",             # rclone source
      "s3:${var.bucket_name}/%s" # rclone target, %s is repo.repo_prefix_python2
    ])
  )

  rclone_python3 = concat(
    local.rclone_base,
    tolist([
      "salt:s3/py3",             # rclone source
      "s3:${var.bucket_name}/%s" # rclone target, %s is repo.repo_prefix_python3
    ])
  )
}

resource "null_resource" "sync_python2" {
  for_each = { for repo in local.repos : repo.id => repo }

  provisioner "local-exec" {
    command = format(
      join(" ", local.rclone_python2),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_python2,
    )
  }

  triggers = {
    rclone = format(
      join(" ", local.rclone_python2),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_python2,
    )
  }
}

resource "null_resource" "sync_python3" {
  for_each = { for repo in local.repos : repo.id => repo }

  provisioner "local-exec" {
    command = format(
      join(" ", local.rclone_python3),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_python3,
    )
  }

  triggers = {
    rclone = format(
      join(" ", local.rclone_python3),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_python3,
    )
  }
}
