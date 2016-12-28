#!/bin/bash
##############################################################################
# pull-salt-repos.sh
#
# DESCRIPTION
# Uses rsync to download salt yum repos associated with a specific salt
# version.
#
# PARAMETERS
# Parameters must be defined as environment variables. Supports the following:
#   REPOSYNC_HTTP_URL
#     (Required) URL where the salt repos will be re-hosted
#   REPOSYNC_SALT_VERSION
#     (Required) Salt version to download
#   REPOSYNC_SALT_RSYNC_URL
#     (Optional) Source rync url to the salt file list. Defaults to
#     "rsync://repo.saltstack.com/saltstack_pkgrepo_rhel"
#   REPOSYNC_STAGING_DIR
#     (Optional) Target directory for rsync. Defaults to
#     "/tmp/${__PROJECTNAME}
#
# CHANGELOG
# 20161228 - LCG - Initial release
##############################################################################
__PROJECTNAME="salt-reposync"
__SCRIPTNAME="pull-salt-repos.sh"

set -eu

# User vars
HTTP_URL="${REPOSYNC_HTTP_URL}"
SALT_VERSION="${REPOSYNC_SALT_VERSION}"
SALT_RSYNC_URL="${REPOSYNC_SALT_RSYNC_URL:-rsync://repo.saltstack.com/saltstack_pkgrepo_rhel}"
STAGING_DIR="${REPOSYNC_STAGING_DIR:-/tmp/${__PROJECTNAME}}"

# Internal vars
HTTP_PATH="$(echo ${HTTP_URL} | grep / | cut -d/ -f4-)"
PACKAGES_DIR="${STAGING_DIR}/${HTTP_PATH}"

# Functions
log()
{
    # Logs messages to logger and stdout
    # Reads log messages from $1 or stdin
    if [[ "${1-UNDEF}" != "UNDEF" ]]
    then
        # Log message is $1
        logger -i -t "${__SCRIPTNAME}" -s -- "$1" 2> /dev/console
        echo "$1"
    else
        # Log message is stdin
        while IFS= read -r IN
        do
            log "$IN"
        done
    fi
}

# Begin work
log "${__SCRIPTNAME} starting!"

# Make dirs
log "Creating directory ${PACKAGES_DIR}"
mkdir -p "${PACKAGES_DIR}"

# Pull salt repos matching $SALT_VERSION
log "Downloading repos for salt ${SALT_VERSION}"
rsync -vazmH --no-links --numeric-ids --delete --delete-after \
    --delay-updates \
    --exclude "*/SRPMS*" \
    --exclude "*/i386*" \
    --exclude "redhat/5*" \
    --include "*/" \
    --include "*/${SALT_VERSION}/**" \
    --exclude "*" \
    $SALT_RSYNC_URL ${PACKAGES_DIR} 2>&1 | log

# Wrap up
log "Salt repos are located in ${PACKAGES_DIR}"
log "${__SCRIPTNAME} done!"
