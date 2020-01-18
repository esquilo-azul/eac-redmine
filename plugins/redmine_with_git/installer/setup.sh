# Auxiliary functions
function sanitize_boolean_var {
  if [ "$1" != 'false' -a "$1" != 'true' ]; then
    if [ -n "$1" ]; then
      echo 'true'
    else
      echo 'false'
    fi
  else
    echo "$1"
  fi
}

function set_by_boolean {
  local value="${!1}"
  if [ "$(sanitize_boolean_var "$value")" == 'true' ]; then
    export $2=$3
  else
    export $2=$4
  fi
}

set_by_boolean address_https address_scheme https http
set_by_boolean git_repositories_hierarchical_organisation git_repositories_unique_repo_identifier \
  false true

# Auxiliary settings
export REDMINE_WITH_GIT_INSTALL_ROOT="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"
export REDMINE_WITH_GIT_TEMPLATE_ROOT="${REDMINE_WITH_GIT_INSTALL_ROOT}/installer/template"

# Redmine configuration
if [ ! -v 'REDMINE_CONFIGURATION_EXTRA' ]; then
  export REDMINE_CONFIGURATION_EXTRA=''
fi
export REDMINE_CONFIGURATION_EXTRA+="  scm_xiolite_command: /usr/bin/git"
