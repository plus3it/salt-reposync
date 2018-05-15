locals {
  skip_module           = "${var.salt_version == ""}"
  salt_versions         = "${sort(distinct(concat(list(var.salt_version), var.extra_salt_versions)))}"
  salt_versions_include = "${formatlist("--include \"*/%s/**\"", local.salt_versions)}"
}

locals {
  rsync_command = [
    "rsync -vazmH --no-links --numeric-ids --delete --delete-excluded --delete-after",
    "--exclude \"*/SRPMS\"",
    "--exclude \"*/i386*\"",
    "--exclude \"redhat/5*\"",
    "--include \"*/\"",
    "${join(" ", local.salt_versions_include)}",
    "--exclude \"*\"",
    "${var.salt_rsync_url} ${var.cache_dir}",
  ]
}

resource "null_resource" "pull" {
  count = "${local.skip_module ? 0 : 1}"

  provisioner "local-exec" {
    command = "${join(" ", local.rsync_command)}"
  }

  triggers {
    salt_versions = "${join(",", local.salt_versions)}"
  }
}

locals {
  s3_command = [
    "aws s3 sync --delete",
    "${var.cache_dir}",
    "s3://${var.bucket_name}/${replace(var.repo_prefix, "/[/]$/", "")}",
  ]

  s3_command_destroy = [
    "aws s3 rm --recursive",
    "s3://${var.bucket_name}/${replace(var.repo_prefix, "/[/]$/", "")}",
  ]
}

resource "null_resource" "push" {
  count = "${local.skip_module ? 0 : 1}"

  provisioner "local-exec" {
    command = "${join(" ", local.s3_command)}"
  }

  provisioner "local-exec" {
    command = "${join(" ", local.s3_command_destroy)}"
    when    = "destroy"
  }

  triggers {
    salt_versions = "${join(",", local.salt_versions)}"
    s3_command    = "${join(" ", local.s3_command)}"
  }

  depends_on = ["null_resource.pull"]
}
