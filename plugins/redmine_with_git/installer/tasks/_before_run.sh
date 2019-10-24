# Default settings
export gitolite_user=git
export gitolite_user_home=/var/lib/git
export redmine_git_hosting_ssh_key_name=redmine_git_hosting_id

# Auxiliary settings
export REDMINE_WITH_GIT_INSTALL_ROOT="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"
export REDMINE_WITH_GIT_TEMPLATE_ROOT="${REDMINE_WITH_GIT_INSTALL_ROOT}/template"

# Task dependencies
taskeiro_add_dependency redmine_bundle redmine_with_git_bundle_requirements
