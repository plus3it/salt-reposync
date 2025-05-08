locals {
  s3_repos = [
    for repo in var.repos : {
      id                  = "${repo.salt_s3_endpoint}_${repo.repo_prefix}"
      repo_prefix_onedir  = "${trim(repo.repo_prefix, "/")}/onedir"
      repo_prefix_python3 = "${trim(repo.repo_prefix, "/")}/python3"
      salt_s3_bucket      = repo.salt_s3_bucket
      salt_s3_endpoint    = repo.salt_s3_endpoint
      salt_versions       = formatlist("--filter '+ {amazon,redhat}/{latest,?}/**/{archive,minor}/%s/**'", sort(repo.salt_versions))
    }
    if repo.repo_type == "s3"
  ]

  webdav_repos = [
    for repo in var.repos : {
      id                   = "${repo.salt_webdav_url}:${repo.repo_prefix}"
      repo_gpgkey_filename = repo.repo_gpgkey_filename
      repo_prefix_onedir   = "${trim(repo.repo_prefix, "/")}/onedir"
      repo_prefix_python3  = "${trim(repo.repo_prefix, "/")}/python3"
      salt_gpgkey_url      = repo.salt_gpgkey_url
      salt_webdav_url      = repo.salt_webdav_url
      salt_versions        = formatlist("--filter '+ *%s*'", sort(repo.salt_versions))
    }
    if repo.repo_type == "webdav"
  ]

  rclone_s3_base = [
    "RCLONE_CONFIG_SALT_TYPE=s3",
    "RCLONE_CONFIG_SALT_PROVIDER=Other",
    "RCLONE_CONFIG_SALT_ENV_AUTH=false",
    "RCLONE_CONFIG_SALT_ENDPOINT=%s", # %s is repo.salt_s3_endpoint
    "rclone sync",
    "--delete-excluded --use-server-modtime --update --fast-list -v",
    "--filter '- **/{i386,i686,SRPMS}/**'",
    "%s", # %s is repo.salt_versions
    "--filter '- *'",
  ]

  rclone_s3_onedir = concat(
    local.rclone_s3_base,
    [
      "salt:%s/salt/py3",                                    # rclone source, %s is repo.salt_s3_bucket
      ":s3,provider=AWS,env_auth=true:${var.bucket_name}/%s" # rclone target, %s is repo.repo_prefix_onedir
    ]
  )

  rclone_s3_python3 = concat(
    local.rclone_s3_base,
    [
      "salt:%s/py3",                                         # rclone source, %s is repo.salt_s3_bucket
      ":s3,provider=AWS,env_auth=true:${var.bucket_name}/%s" # rclone target, %s is repo.repo_prefix_python3
    ]
  )

  # See: https://docs.saltproject.io/salt/install-guide/en/latest/topics/other-install-types/air-gap-install.html#create-a-local-mirror-with-rclone-faster
  rclone_webdav_base = [
    "RCLONE_CONFIG_SALT_TYPE=webdav",
    "RCLONE_CONFIG_SALT_VENDOR=other",
    "RCLONE_CONFIG_SALT_URL=%s", # %s is repo.salt_webdav_url
    "rclone sync",
    "--delete-excluded --use-server-modtime --update --fast-list -v",
    "--filter '- {*.md5,*.sha1,*.sha256}'",
    "--filter '+ repodata/**'",
    "%s", # %s is repo.salt_versions
    "--filter '- *'",
  ]

  rclone_webdav_onedir = concat(
    local.rclone_webdav_base,
    [
      "salt:saltproject-rpm/",                               # rclone source
      ":s3,provider=AWS,env_auth=true:${var.bucket_name}/%s" # rclone target, %s is repo.repo_prefix_onedir
    ]
  )
}

resource "null_resource" "sync_s3_onedir" {
  for_each = { for repo in local.s3_repos : repo.id => repo }

  provisioner "local-exec" {
    command = format(
      join(" ", local.rclone_s3_onedir),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.salt_s3_bucket,
      each.value.repo_prefix_onedir,
    )
  }

  triggers = {
    rclone = format(
      join(" ", local.rclone_s3_onedir),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.salt_s3_bucket,
      each.value.repo_prefix_onedir,
    )
  }
}

resource "null_resource" "sync_s3_python3" {
  for_each = { for repo in local.s3_repos : repo.id => repo }

  provisioner "local-exec" {
    command = format(
      join(" ", local.rclone_s3_python3),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.salt_s3_bucket,
      each.value.repo_prefix_python3,
    )
  }

  triggers = {
    rclone = format(
      join(" ", local.rclone_s3_python3),
      each.value.salt_s3_endpoint,
      join(" ", each.value.salt_versions),
      each.value.salt_s3_bucket,
      each.value.repo_prefix_python3,
    )
  }
}

resource "terraform_data" "sync_webdav_onedir" {
  for_each = { for repo in local.webdav_repos : repo.id => repo }

  provisioner "local-exec" {
    command = format(
      join(" ", local.rclone_webdav_onedir),
      each.value.salt_webdav_url,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_onedir,
    )
  }

  triggers_replace = [
    format(
      join(" ", local.rclone_webdav_onedir),
      each.value.salt_webdav_url,
      join(" ", each.value.salt_versions),
      each.value.repo_prefix_onedir,
    )
  ]
}

resource "terraform_data" "gpgkey_webdav_onedir" {
  for_each = { for repo in local.webdav_repos : repo.id => repo if repo.salt_gpgkey_url != null }

  provisioner "local-exec" {
    command = "rclone copyurl -v ${each.value.salt_gpgkey_url} :s3,provider=AWS,env_auth=true:${var.bucket_name}/${each.value.repo_prefix_onedir}/${each.value.repo_gpgkey_filename}"
  }

  triggers_replace = [
    "rclone copyurl -v ${each.value.salt_gpgkey_url} :s3,provider=AWS,env_auth=true:${var.bucket_name}/${each.value.repo_prefix_onedir}/${each.value.repo_gpgkey_filename}"
  ]
}
