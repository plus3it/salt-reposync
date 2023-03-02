locals {
  repos = [
    for repo in var.repos : {
      salt_versions = sort(repo.salt_versions)
      repo_endpoint = "${trimsuffix(var.repo_endpoint, "/")}/${trim(repo.repo_prefix, "/")}"
      yum_prefix    = trim(repo.yum_prefix, "/")
    }
  ]
}

locals {
  repo_paths = {
    amzn2-onedir  = "onedir/amazon/2/$basearch/archive"
    amzn2-python3 = "python3/amazon/2/$basearch/archive"
    el7-onedir    = "onedir/redhat/7/$basearch/archive"
    el7-python3   = "python3/redhat/7/$basearch/archive"
    el8-onedir    = "onedir/redhat/8/$basearch/archive"
    el8-python3   = "python3/redhat/8/$basearch/archive"
    el9-onedir    = "onedir/redhat/9/$basearch/archive"
  }

  repo_defs = flatten([
    for repo in local.repos : [
      for version in repo.salt_versions : [
        for platform, repo_path in local.repo_paths : {
          key = "${repo.yum_prefix}/${version}/salt-reposync-${platform}.repo"
          content = templatefile(
            "${path.module}/yum.repo",
            {
              name    = "salt-reposync-${platform}"
              baseurl = "${repo.repo_endpoint}/${repo_path}/${version}"
              gpgkey  = "${repo.repo_endpoint}/${repo_path}/${version}/SALTSTACK-GPG-KEY.pub"
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
