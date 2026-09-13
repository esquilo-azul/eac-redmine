#!/bin/bash

set -u
set -e

function ssh_client_known_hosts_file {
  printf '%s/known_hosts' "$(dirname "$(programeiro /redmine_git_hosting/ssh_key)")"
}

function ssh_client_known_hosts_spec {
  var_set_by SSH_SERVER_PORT programeiro /redmine_git_hosting/ssh_server_port
  if [ "$SSH_SERVER_PORT" == '22' ]; then
    printf '%s' "$SSH_SERVER_HOST"
  else
    printf '[%s]:%s' "$SSH_SERVER_HOST" "$SSH_SERVER_PORT"
  fi
}

function ssh_client_known_hosts_entries_count {
  local known_hosts
  known_hosts="$(ssh_client_known_hosts_file)"
  [ -f "$known_hosts" ] || { echo 0; return; }
  sudo -u "$(programeiro /rails/user)" \
    ssh-keygen -F "$(ssh_client_known_hosts_spec)" -f "$known_hosts" | grep -vc '^#'
}

function ssh_client_known_hosts_connection_ok {
  programeiro /redmine_git_hosting/ssh_run yes info >/dev/null 2>&1
}

function task_dependencies {
  echo redmine_git_hosting_ssh_key ssh_server_running
}

function task_condition {
  [ "$(ssh_client_known_hosts_entries_count)" == '1' ] && ssh_client_known_hosts_connection_ok
}

function task_fix {
  local known_hosts
  known_hosts="$(ssh_client_known_hosts_file)"
  sudo -u "$(programeiro /rails/user)" \
    ssh-keygen -R "$(ssh_client_known_hosts_spec)" -f "$known_hosts" >/dev/null 2>&1 || true
  programeiro /redmine_git_hosting/ssh_run no info
}
