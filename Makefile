.PHONY: help deps sync.s3

help:
	@echo
	@more README.md

deps:
	@echo "make: Processing make deps"
	yum -y install zip

sync.s3: deps
	@echo "make: Processing make sync"
	@bash bin/pull-salt-repos.sh
	@bash bin/prep-salt-repos.sh
	@bash bin/push-salt-repos.sh
