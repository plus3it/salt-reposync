locals {
  repos = [
    for repo in var.repos : {
      salt_versions        = sort(repo.salt_versions)
      repo_endpoint        = "${trimsuffix(var.repo_endpoint, "/")}/${trim(repo.repo_prefix, "/")}"
      repo_gpgkey_filename = repo.repo_gpgkey_filename
      yum_prefix           = trim(repo.yum_prefix, "/")
    }
  ]
}

locals {
  repo_paths = {
    onedir = "onedir"
  }

  repo_defs = flatten([
    for repo in local.repos : [
      for version in repo.salt_versions : [
        for platform, repo_path in local.repo_paths : {
          key = "${repo.yum_prefix}/${version}/salt-reposync-${platform}.repo"
          content = templatefile(
            "${path.module}/yum.repo",
            {
              name        = "salt-reposync-${platform}"
              baseurl     = "${repo.repo_endpoint}/${repo_path}"
              gpgkey      = "${repo.repo_endpoint}/${repo_path}/${repo.repo_gpgkey_filename}"
              includepkgs = format("*%s*", version)
            }
          )
        }
      ]
    ]
  ])
}

resource "aws_s3_object" "this" {
  for_each = { for repo_def in local.repo_defs : repo_def.key => repo_def.content }

  bucket       = var.bucket_name
  key          = each.key
  content      = each.value
  content_type = "text/plain"
  etag         = md5(each.value)
}
