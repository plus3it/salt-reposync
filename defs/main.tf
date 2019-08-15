locals {
  skip_module   = "${var.salt_version == ""}"
  salt_versions = "${sort(distinct(concat(list(var.salt_version), var.extra_salt_versions)))}"
  repo_prefix   = "${replace("${var.s3_endpoint}/${var.bucket_name}/${var.repo_prefix}", "/[/]$/", "")}"
}

data "null_data_source" "amzn" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  inputs {
    name    = "salt-reposync-amzn"
    baseurl = "${local.repo_prefix}/python2/amazon/latest/$basearch/archive/${local.salt_versions[count.index]}"
    gpgkey  = "${local.repo_prefix}/python2/amazon/latest/$basearch/archive/${local.salt_versions[count.index]}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el6" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  inputs {
    name    = "salt-reposync-el6"
    baseurl = "${local.repo_prefix}/python2/redhat/6/$basearch/archive/${local.salt_versions[count.index]}"
    gpgkey  = "${local.repo_prefix}/python2/redhat/6/$basearch/archive/${local.salt_versions[count.index]}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el7" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  inputs {
    name    = "salt-reposync-el7"
    baseurl = "${local.repo_prefix}/python2/redhat/7/$basearch/archive/${local.salt_versions[count.index]}"
    gpgkey  = "${local.repo_prefix}/python2/redhat/7/$basearch/archive/${local.salt_versions[count.index]}/SALTSTACK-GPG-KEY.pub"
  }
}

data "null_data_source" "el7_python3" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  inputs {
    name    = "salt-reposync-el7-python3"
    baseurl = "${local.repo_prefix}/python3/7/$basearch/archive/${local.salt_versions[count.index]}"
    gpgkey  = "${local.repo_prefix}/python3/7/$basearch/archive/${local.salt_versions[count.index]}/SALTSTACK-GPG-KEY.pub"
  }
}

data "template_file" "amzn" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  template = "${file("${path.module}/yum.repo")}"

  vars {
    name    = "${lookup(data.null_data_source.amzn.*.outputs[count.index], "name")}"
    baseurl = "${lookup(data.null_data_source.amzn.*.outputs[count.index], "baseurl")}"
    gpgkey  = "${lookup(data.null_data_source.amzn.*.outputs[count.index], "gpgkey")}"
  }
}

data "template_file" "el6" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  template = "${file("${path.module}/yum.repo")}"

  vars {
    name    = "${lookup(data.null_data_source.el6.*.outputs[count.index], "name")}"
    baseurl = "${lookup(data.null_data_source.el6.*.outputs[count.index], "baseurl")}"
    gpgkey  = "${lookup(data.null_data_source.el6.*.outputs[count.index], "gpgkey")}"
  }
}

data "template_file" "el7" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  template = "${file("${path.module}/yum.repo")}"

  vars {
    name    = "${lookup(data.null_data_source.el7.*.outputs[count.index], "name")}"
    baseurl = "${lookup(data.null_data_source.el7.*.outputs[count.index], "baseurl")}"
    gpgkey  = "${lookup(data.null_data_source.el7.*.outputs[count.index], "gpgkey")}"
  }
}

data "template_file" "el7_python3" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  template = "${file("${path.module}/yum.repo")}"

  vars {
    name    = "${lookup(data.null_data_source.el7_python3.*.outputs[count.index], "name")}"
    baseurl = "${lookup(data.null_data_source.el7_python3.*.outputs[count.index], "baseurl")}"
    gpgkey  = "${lookup(data.null_data_source.el7_python3.*.outputs[count.index], "gpgkey")}"
  }
}

resource "local_file" "amzn" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  content  = "${data.template_file.amzn.*.rendered[count.index]}"
  filename = "${var.cache_dir}/${local.salt_versions[count.index]}/salt-reposync-amzn.repo"
}

resource "local_file" "el6" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  content  = "${data.template_file.el6.*.rendered[count.index]}"
  filename = "${var.cache_dir}/${local.salt_versions[count.index]}/salt-reposync-el6.repo"
}

resource "local_file" "el7" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  content  = "${data.template_file.el7.*.rendered[count.index]}"
  filename = "${var.cache_dir}/${local.salt_versions[count.index]}/salt-reposync-el7.repo"
}

resource "local_file" "el7_python3" {
  count = "${local.skip_module ? 0 : length(local.salt_versions)}"

  content  = "${data.template_file.el7_python3.*.rendered[count.index]}"
  filename = "${var.cache_dir}/${local.salt_versions[count.index]}/salt-reposync-el7-python3.repo"
}

resource "local_file" "amzn_default" {
  count = "${local.skip_module ? 0 : 1}"

  content  = "${data.template_file.amzn.*.rendered[index(local.salt_versions, var.salt_version)]}"
  filename = "${var.cache_dir}/salt-reposync-amzn.repo"
}

resource "local_file" "el6_default" {
  count = "${local.skip_module ? 0 : 1}"

  content  = "${data.template_file.el6.*.rendered[index(local.salt_versions, var.salt_version)]}"
  filename = "${var.cache_dir}/salt-reposync-el6.repo"
}

resource "local_file" "el7_default" {
  count = "${local.skip_module ? 0 : 1}"

  content  = "${data.template_file.el7.*.rendered[index(local.salt_versions, var.salt_version)]}"
  filename = "${var.cache_dir}/salt-reposync-el7.repo"
}

resource "local_file" "el7_python3_default" {
  count = "${local.skip_module ? 0 : 1}"

  content  = "${data.template_file.el7_python3.*.rendered[index(local.salt_versions, var.salt_version)]}"
  filename = "${var.cache_dir}/salt-reposync-el7-python3.repo"
}

locals {
  s3_command = [
    "aws s3 sync --delete",
    "${var.cache_dir}",
    "s3://${var.bucket_name}/${replace(var.yum_prefix, "/[/]$/", "")}",
  ]

  s3_command_destroy = [
    "aws s3 rm --recursive",
    "s3://${var.bucket_name}/${replace(var.yum_prefix, "/[/]$/", "")}",
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
    repo_prefix   = "${local.repo_prefix}"
    salt_versions = "${join(",", local.salt_versions)}"
    s3_command    = "${join(" ", local.s3_command)}"
  }

  depends_on = [
    "local_file.amzn",
    "local_file.el6",
    "local_file.el7",
    "local_file.el7_python3",
    "local_file.amzn_default",
    "local_file.el6_default",
    "local_file.el7_default",
    "local_file.el7_python3_default",
  ]
}
