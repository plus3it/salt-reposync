#!/bin/bash
##############################################################################
# push-salt-repos.sh
#
# DESCRIPTION
# Pushes salt repos to an s3 bucket.
#
# PARAMETERS
# Parameters must be defined as environment variables. Supports the following:
#   REPOSYNC_HTTP_URL
#     (Required) URL where the salt repos will be re-hosted
#   REPOSYNC_STAGING_DIR
#     (Optional) Target directory for rsync. Defaults to
#     "/tmp/${__PROJECTNAME}
#
# CHANGELOG
# 20161228 - LCG - Initial release
##############################################################################
__PROJECTNAME="salt-reposync"
__SCRIPTNAME="push-salt-repos.sh"

set -eu
set -o pipefail

# User vars
HTTP_URL="${REPOSYNC_HTTP_URL}"
STAGING_DIR="${REPOSYNC_STAGING_DIR:-/tmp/${__PROJECTNAME}}"
CREATE_ARCHIVE="${REPOSYNC_ARCHIVE:-true}"

# Internal vars
HTTP_PATH="$(echo ${HTTP_URL} | grep / | cut -d/ -f4-)"
REPO_DIR="${STAGING_DIR}/${HTTP_PATH}"
ARCHIVE_DIR="${REPO_DIR}/archives"

# Functions
log()
{
    # Logs messages to logger and stdout
    # Reads log messages from $1 or stdin
    if [[ "${1-UNDEF}" != "UNDEF" ]]
    then
        # Log message is $1
        logger -i -t "${__SCRIPTNAME}" -s -- "$1" 2> /dev/console
        echo "${__SCRIPTNAME}: $1"
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

if [[ "${CREATE_ARCHIVE}" = "true" ]]
then
    # Make archive dirs
    log "Creating directory ${ARCHIVE_DIR}"
    mkdir -p "${ARCHIVE_DIR}"

    # Retrieving archives
    log "Retrieving zip archives"
    aws s3 sync "s3://${HTTP_PATH}/archives" "${ARCHIVE_DIR}/" 2>&1 | log

    # Create a delta zip archive, comparing new files to the last full zip archive
    log "Creating a delta zip archive"
    cd "${REPO_DIR}"
    datestamp=$(date -u +"%Y%m%d")
    delta_zip="${__PROJECTNAME}-yum-delta-${datestamp}.zip"
    lastfull="$(
        find ${ARCHIVE_DIR} -type f | \
        grep -i -e "${__PROJECTNAME}-yum-full-.*\.zip" | \
        sort -r | \
        head -1 || echo UNDEF)"
    if [[ "${lastfull}" != "UNDEF" ]]
    then
        zip -r "${lastfull}" . -DF \
            --out "./archives/${delta_zip}" \
            -x "archives*" 2>&1 | log
    fi

    # Now create a zip with all the current files
    log "Creating a full zip archive"
    cd "${REPO_DIR}"
    full_zip="${__PROJECTNAME}-yum-full-${datestamp}.zip"
    zip -r "./archives/${full_zip}" . \
        -x "archives/${__PROJECTNAME}-*.zip" 2>&1 | log
fi

# Push salt repos
log "Pushing salt repos to ${HTTP_URL}"
cd "${REPO_DIR}"
aws s3 sync . "s3://${HTTP_PATH}" 2>&1 | log

# Wrap up
log "Salt repos are hosted at ${HTTP_URL}"
log "${__SCRIPTNAME} done!"
