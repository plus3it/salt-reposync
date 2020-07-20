terraform {
  required_version = ">= 0.12"
}

module "main" {
  source = "../.."

  bucket_name   = "foo"
  repo_endpoint = "bar"
  repos         = []
}
