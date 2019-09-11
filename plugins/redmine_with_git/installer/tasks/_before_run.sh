# Auxilary functions
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

# Default settings
export address_https=false
export address_host=localhost
export address_port=
set_by_boolean address_https address_scheme https http
export address_server="$address_host"
if [ -n "$address_port" ]; then
  export address_server="$address_server:$address_port"
fi
export git_repositories_hierarchical_organisation=true
set_by_boolean git_repositories_hierarchical_organisation git_repositories_unique_repo_identifier \
  false true
export gitolite_user=git
export gitolite_user_home=/var/lib/git
export redmine_git_hosting_ssh_key_name=redmine_git_hosting_id

# Auxiliary settings
export REDMINE_WITH_GIT_INSTALL_ROOT="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"
export REDMINE_WITH_GIT_TEMPLATE_ROOT="${REDMINE_WITH_GIT_INSTALL_ROOT}/template"

# Task dependencies
taskeiro_add_dependency redmine_bundle redmine_with_git_bundle_requirements
taskeiro_add_dependency development redmine_git_hosting
