locals {
  disable       = var.salt_version == ""
  salt_versions = sort(distinct(concat(list(var.salt_version), var.extra_salt_versions)))
  repo_endpoint = "${replace(var.repo_endpoint, "/[/]*$/", "")}/${replace(var.repo_prefix, "/[/]*$/", "")}"
}

data "null_data_source" "amzn" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  inputs = {
    name    = "salt-reposync-amzn"
    baseurl = "${local.repo_endpoint}/python2/amazon/latest/$basearch/archive/${each.key}"
    gpgkey  = "${local.repo_endpoint}/python2/amazon/latest/$basearch/archive/${each.key}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el6" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  inputs = {
    name    = "salt-reposync-el6"
    baseurl = "${local.repo_endpoint}/python2/redhat/6/$basearch/archive/${each.key}"
    gpgkey  = "${local.repo_endpoint}/python2/redhat/6/$basearch/archive/${each.key}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el7" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  inputs = {
    name    = "salt-reposync-el7"
    baseurl = "${local.repo_endpoint}/python2/redhat/7/$basearch/archive/${each.key}"
    gpgkey  = "${local.repo_endpoint}/python2/redhat/7/$basearch/archive/${each.key}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el7_python3" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  inputs = {
    name    = "salt-reposync-el7-python3"
    baseurl = "${local.repo_endpoint}/python3/7/$basearch/archive/${each.key}"
    gpgkey  = "${local.repo_endpoint}/python3/7/$basearch/archive/${each.key}/SALTSTACK-GPG-KEY.pub"
  }
}

resource "local_file" "amzn" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  filename = "${var.cache_dir}/${each.key}/salt-reposync-amzn.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.amzn[each.key].outputs.name
      baseurl = data.null_data_source.amzn[each.key].outputs.baseurl
      gpgkey  = data.null_data_source.amzn[each.key].outputs.gpgkey
    }
  )
}

resource "local_file" "el6" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  filename = "${var.cache_dir}/${each.key}/salt-reposync-el6.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el6[each.key].outputs.name
      baseurl = data.null_data_source.el6[each.key].outputs.baseurl
      gpgkey  = data.null_data_source.el6[each.key].outputs.gpgkey
    }
  )
}

resource "local_file" "el7" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  filename = "${var.cache_dir}/${each.key}/salt-reposync-el7.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el7[each.key].outputs.name
      baseurl = data.null_data_source.el7[each.key].outputs.baseurl
      gpgkey  = data.null_data_source.el7[each.key].outputs.gpgkey
    }
  )
}

resource "local_file" "el7_python3" {
  for_each = local.disable ? set() : toset(local.salt_versions)

  filename = "${var.cache_dir}/${each.key}/salt-reposync-el7-python3.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el7_python3[each.key].outputs.name
      baseurl = data.null_data_source.el7_python3[each.key].outputs.baseurl
      gpgkey  = data.null_data_source.el7_python3[each.key].outputs.gpgkey
    }
  )
}

resource "local_file" "amzn_default" {
  count = local.disable ? 0 : 1

  filename = "${var.cache_dir}/salt-reposync-amzn.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.amzn[var.salt_version].outputs.name
      baseurl = data.null_data_source.amzn[var.salt_version].outputs.baseurl
      gpgkey  = data.null_data_source.amzn[var.salt_version].outputs.gpgkey
    }
  )
}

resource "local_file" "el6_default" {
  count = local.disable ? 0 : 1

  filename = "${var.cache_dir}/salt-reposync-el6.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el6[var.salt_version].outputs.name
      baseurl = data.null_data_source.el6[var.salt_version].outputs.baseurl
      gpgkey  = data.null_data_source.el6[var.salt_version].outputs.gpgkey
    }
  )
}

resource "local_file" "el7_default" {
  count = local.disable ? 0 : 1

  filename = "${var.cache_dir}/salt-reposync-el7.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el7[var.salt_version].outputs.name
      baseurl = data.null_data_source.el7[var.salt_version].outputs.baseurl
      gpgkey  = data.null_data_source.el7[var.salt_version].outputs.gpgkey
    }
  )
}

resource "local_file" "el7_python3_default" {
  count = local.disable ? 0 : 1

  filename = "${var.cache_dir}/salt-reposync-el7-python3.repo"

  content = templatefile(
    "${path.module}/yum.repo",
    {
      name    = data.null_data_source.el7_python3[var.salt_version].outputs.name
      baseurl = data.null_data_source.el7_python3[var.salt_version].outputs.baseurl
      gpgkey  = data.null_data_source.el7_python3[var.salt_version].outputs.gpgkey
    }
  )
}

locals {
  s3_command = [
    "aws s3 sync --delete",
    var.cache_dir,
    "s3://${var.bucket_name}/${replace(var.yum_prefix, "/[/]$/", "")}",
  ]

  s3_command_destroy = [
    "aws s3 rm --recursive",
    "s3://${var.bucket_name}/${replace(var.yum_prefix, "/[/]$/", "")}",
  ]
}

resource "null_resource" "push" {
  count = local.disable ? 0 : 1

  provisioner "local-exec" {
    command = join(" ", local.s3_command)
  }

  provisioner "local-exec" {
    command = join(" ", local.s3_command_destroy)
    when    = destroy
  }

  triggers = {
    repo_endpoint                  = local.repo_endpoint
    salt_versions                  = join(",", local.salt_versions)
    s3_command                     = join(" ", local.s3_command)
    local_file_amzn                = md5(join("", [for f in local_file.amzn : f.content]))
    local_file_el6                 = md5(join("", [for f in local_file.el6 : f.content]))
    local_file_el7                 = md5(join("", [for f in local_file.el7 : f.content]))
    local_file_el7_python3         = md5(join("", [for f in local_file.el7_python3 : f.content]))
    local_file_amzn_default        = md5(join("", local_file.amzn_default.*.content))
    local_file_el6_default         = md5(join("", local_file.el6_default.*.content))
    local_file_el7_default         = md5(join("", local_file.el7_default.*.content))
    local_file_el7_python3_default = md5(join("", local_file.el7_python3_default.*.content))
  }

  depends_on = [
    local_file.amzn,
    local_file.el6,
    local_file.el7,
    local_file.el7_python3,
    local_file.amzn_default,
    local_file.el6_default,
    local_file.el7_default,
    local_file.el7_python3_default,
  ]
}
