locals {
  disable             = length(var.salt_versions) == 0
  salt_versions       = formatlist("--filter '+ {amazon,redhat}/{latest,?}/**/archive/%s/**'", sort(var.salt_versions))
  repo_prefix_python2 = trimprefix("${trimsuffix(var.repo_prefix, "/")}/python2", "/")
  repo_prefix_python3 = trimprefix("${trimsuffix(var.repo_prefix, "/")}/python3", "/")
}

locals {
  rclone_base = [
    "RCLONE_CONFIG_SALT_TYPE=s3",
    "RCLONE_CONFIG_SALT_PROVIDER=Other",
    "RCLONE_CONFIG_SALT_ENV_AUTH=false",
    "RCLONE_CONFIG_SALT_ENDPOINT=${var.salt_s3_endpoint}",
    "RCLONE_CONFIG_S3_TYPE=s3",
    "RCLONE_CONFIG_S3_ENV_AUTH=true",
    "rclone sync",
    "--use-server-modtime --update --fast-list -v",
    "--filter '- **/{i386,i686,SRPMS}/**'",
    join(" ", local.salt_versions),
    "--filter '- *'",
  ]

  rclone_python2 = concat(
    local.rclone_base,
    list(
      "salt:s3/yum",                                       # rclone source
      "s3:${var.bucket_name}/${local.repo_prefix_python2}" # rclone target
    )
  )

  rclone_python3 = concat(
    local.rclone_base,
    list(
      "salt:s3/py3",                                       # rclone source
      "s3:${var.bucket_name}/${local.repo_prefix_python3}" # rclone target
    )
  )
}

resource "null_resource" "sync_python2" {
  count = local.disable ? 0 : 1

  provisioner "local-exec" {
    command = join(" ", local.rclone_python2)
  }

  triggers = {
    rclone = join(" ", local.rclone_python2)
  }
}

resource "null_resource" "sync_python3" {
  count = local.disable ? 0 : 1

  provisioner "local-exec" {
    command = join(" ", local.rclone_python3)
  }

  triggers = {
    rclone = join(" ", local.rclone_python3)
  }
}
