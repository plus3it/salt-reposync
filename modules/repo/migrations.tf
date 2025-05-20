moved {
  from = null_resource.sync_onedir
  to   = null_resource.sync_s3_onedir
}

moved {
  from = null_resource.sync_python3
  to   = null_resource.sync_s3_python3
}
