help:
	@echo
	@echo '  Usage:'
	@echo '    <PARAM>=<arg> make <target>'
	@echo
	@echo '    See the help section "Environment Variables" for a description of'
	@echo '    the supported env parameters.'
	@echo
	@echo '  Targets:'
	@echo '    help'
	@echo '      Show this help message'
	@echo '    deps'
	@echo '      Install dependencies'
	@echo '    sync.s3'
	@echo '      Run `make deps` and then download salt repos and push them to'
	@echo '      s3. This target supports setting script parameters via'
	@echo '      environment variables. Will return an error if any of the'
	@echo '      required environment variables are unset. See the help section'
	@echo '      "Environment Variables".'
	@echo
	@echo '  Environment Variables:'
	@echo '    REPOSYNC_HTTP_URL'
	@echo '      (Required) URL where the salt repos will be re-hosted'
	@echo '    REPOSYNC_SALT_VERSION'
	@echo '      (Required) Salt version to download'
	@echo '    REPOSYNC_SALT_RSYNC_URL'
	@echo '      (Optional) Source rync url to the salt file list. Defaults to'
	@echo '      "rsync://repo.saltstack.com/saltstack_pkgrepo_rhel"'
	@echo '    REPOSYNC_STAGING_DIR'
	@echo '      (Optional) Target directory for rsync. Defaults to'
	@echo '      "/tmp/${__PROJECTNAME}'

deps:
	@echo "make: Processing make deps"
	yum -y install git zip

sync.s3: deps
	@echo "make: Processing make sync"
	@bash pull-salt-repos.sh
	@bash prep-salt-repos.sh
	@bash push-salt-repos.sh
