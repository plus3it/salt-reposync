# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module mirrors Salt yum repositories into an S3 bucket and writes yum `.repo` definition files for them. The main inputs are `bucket_name`, `repo_endpoint`, and the list `repos`, where each entry names the Salt versions to mirror, the S3 key prefix for the mirror, the S3 key prefix for the definition files, and where to copy from (`repo_type` is `s3` by default, or `webdav`). It runs `rclone` on the machine that runs Terraform. The module has no outputs.

### Module-specific files

- `modules/repo/` — Runs `rclone` through `local-exec` provisioners to copy the Salt packages for the requested versions into the S3 bucket; called by the root module as `sync_repo`
- `modules/repo/migrations.tf` — `moved` blocks that rename `null_resource.sync_onedir` and `null_resource.sync_python3` to the `sync_s3_*` names
- `modules/defs/` — Creates one `aws_s3_object` yum `.repo` file per Salt version and platform, rendered from `modules/defs/yum.repo`; called by the root module as `yum_defs`
- `tests/main/`, `tests/repo/`, `tests/defs/`, `tests/noop/` — Test configurations for the root module, `modules/repo`, `modules/defs`, and the root module with an empty `repos` list. Some of the S3 test cases are commented out in `tests/main/main.tf` and `tests/repo/main.tf`.
- `Dockerfile` — Pins the `plus3it/tardigrade-ci` image version

### Deviations from the terraform-module profile

- There is no `CHANGELOG.md`, so skip the changelog step.
- The version is stored in `.bumpversion.cfg`. The shared `tardigrade-ci` Makefile has `bumpversion/major`, `bumpversion/minor`, and `bumpversion/patch` targets, which run `bumpversion` with the setting `commit = True`, so each run creates a commit. The setting `tag = False` means no tag is created.
- `.github/workflows/release.yml` runs on a push to the `master` branch that changes `.bumpversion.cfg`, and on demand. It calls the shared release workflow, which runs the lint and test jobs and then creates a GitHub Release. A comment in the file says `main`, but the branch filter is `master`.
- The test configurations `tests/main/`, `tests/repo/`, and `tests/defs/` create real S3 buckets, and `tests/main/` and `tests/repo/` use the `webdav` repo type against an external URL, so they do not use the mock AWS stack. Both `test.yml` and `release.yml` set `mockstacktest-enable: false`.
