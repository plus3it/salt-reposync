terraform {
  required_version = ">= 0.12"
}

module "main" {
  source = "../.."

  bucket_name   = "foo"
  salt_versions = []
  repo_endpoint = "bar"
}
