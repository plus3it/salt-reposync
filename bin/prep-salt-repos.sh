#!/bin/bash
##############################################################################
# prep-salt-repos.sh
#
# DESCRIPTION
# Creates yum repo definitions for salt repos.
#
# PARAMETERS
# Parameters must be defined as environment variables. Supports the following:
#   REPOSYNC_HTTP_URL
#     (Required) URL where the salt repos will be re-hosted
#   REPOSYNC_SALT_VERSION
#     (Required) Salt version to download
#   REPOSYNC_STAGING_DIR
#     (Optional) Target directory for rsync. Defaults to
#     "/tmp/${__PROJECTNAME}
#
# CHANGELOG
# 20161228 - LCG - Initial release
##############################################################################
__PROJECTNAME="salt-reposync"
__SCRIPTNAME="prep-salt-repos.sh"

set -eu
set -o pipefail

# User vars
HTTP_URL="${REPOSYNC_HTTP_URL}"
SALT_VERSION="${REPOSYNC_SALT_VERSION}"
STAGING_DIR="${REPOSYNC_STAGING_DIR:-/tmp/${__PROJECTNAME}}"

# Internal vars
HTTP_PATH="$(echo ${HTTP_URL} | grep / | cut -d/ -f4-)"
REPOS=(
    "SALT_AMAZON"
    "SALT_EL6"
    "SALT_EL7"
)
YUM_FILE_DIR="${STAGING_DIR}/${HTTP_PATH}/yum.repos"

# amzn repo vars
REPO_NAME_SALT_AMAZON="${__PROJECTNAME}-amzn"
REPO_BASEURL_SALT_AMAZON="${HTTP_URL}/amazon/latest/\$basearch/archive/${SALT_VERSION}"
REPO_GPGKEY_SALT_AMAZON="${HTTP_URL}/amazon/latest/\$basearch/archive/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub"

# el6 repo vars
REPO_NAME_SALT_EL6="${__PROJECTNAME}-el6"
REPO_BASEURL_SALT_EL6="${HTTP_URL}/redhat/6/\$basearch/archive/${SALT_VERSION}"
REPO_GPGKEY_SALT_EL6="${HTTP_URL}/redhat/6/\$basearch/archive/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub"

# el7 repo vars
REPO_NAME_SALT_EL7="${__PROJECTNAME}-el7"
REPO_BASEURL_SALT_EL7="${HTTP_URL}/redhat/7/\$basearch/archive/${SALT_VERSION}"
REPO_GPGKEY_SALT_EL7="${HTTP_URL}/redhat/7/\$basearch/archive/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub"

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

print_repo_file() {
    # Function that prints out a yum repo file
    if [ $# -eq 3 ]
    then
        name="$1"
        baseurl="$2"
        gpgkey="$3"
    else
        printf "ERROR: print_repo_file requires three arguments." 1>&2
        exit 1
    fi
    printf "[%s]\n" "${name}"
    printf "name=%s\n" "${name}"
    printf "baseurl=%s\n" "${baseurl}"
    printf "failovermethod=priority\n"
    printf "priority=10"
    printf "gpgcheck=1\n"
    printf "gpgkey=%s\n" "${gpgkey}"
    printf "enabled=1\n"
    printf "skip_if_unavailable=1\n"
}

# Begin work
log "${__SCRIPTNAME} starting!"

# Make dirs
log "Creating directory ${YUM_FILE_DIR}"
mkdir -p "${YUM_FILE_DIR}"

# Create repo files
log "Creating yum repo files"
for repo in "${REPOS[@]}"; do
    repo_name="REPO_NAME_${repo}"
    repo_baseurl="REPO_BASEURL_${repo}"
    repo_gpgkey="REPO_GPGKEY_${repo}"
    print_repo_file "${!repo_name}" "${!repo_baseurl}" "${!repo_gpgkey}" \
        > "${YUM_FILE_DIR}/${!repo_name}.repo"
done

# Wrap up
log "Yum repo files are located in ${YUM_FILE_DIR}"
log "${__SCRIPTNAME} done!"
