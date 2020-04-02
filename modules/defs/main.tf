locals {
  salt_versions = sort(var.salt_versions)
  repo_endpoint = "${trimsuffix(var.repo_endpoint, "/")}/${trim(var.repo_prefix, "/")}"
  yum_prefix    = trim(var.yum_prefix, "/")
}

locals {

  repo_endpoints = {
    amzn          = "${local.repo_endpoint}/python2/amazon/latest/$basearch/archive"
    amzn2         = "${local.repo_endpoint}/python2/amazon/2/$basearch/archive"
    amzn2-python3 = "${local.repo_endpoint}/python3/amazon/2/$basearch/archive"
    el6           = "${local.repo_endpoint}/python2/redhat/6/$basearch/archive"
    el7           = "${local.repo_endpoint}/python2/redhat/7/$basearch/archive"
    el7-python3   = "${local.repo_endpoint}/python3/redhat/7/$basearch/archive"
    el8           = "${local.repo_endpoint}/python2/redhat/8/$basearch/archive"
    el8-python3   = "${local.repo_endpoint}/python3/redhat/8/$basearch/archive"
  }

  repo_defs = flatten([
    for version in local.salt_versions : [
      for repo, endpoint in local.repo_endpoints : {
        key = "${local.yum_prefix}/${version}/salt-reposync-${repo}.repo"
        content = templatefile(
          "${path.module}/yum.repo",
          {
            name    = "salt-reposync-${repo}"
            baseurl = "${endpoint}/${version}"
            gpgkey  = "${endpoint}/${version}/SALTSTACK-GPG-KEY.pub"
          }
        )
      }
    ]
  ])
}

resource "aws_s3_bucket_object" "this" {
  for_each = { for repo_def in local.repo_defs : repo_def.key => repo_def.content }

  bucket       = var.bucket_name
  key          = each.key
  content      = each.value
  content_type = "text/plain"
  etag         = md5(each.value)
}
