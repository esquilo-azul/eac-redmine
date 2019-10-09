#!/bin/bash

set -u
set -e

export INSTALL_ROOT2=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export REDMINE_ROOT=$(dirname "$(dirname "$INSTALL_ROOT2")")
export PLUGIN_ROOT="$REDMINE_ROOT/plugins/redmine_installer"
export INSTALL_ROOT="$PLUGIN_ROOT/installer"
export TASK=''

SAMPLE_SETTINGS="$INSTALL_ROOT2/default-settings.sh"
DEFAULT_SETTINGS="$REDMINE_ROOT/config/install.sh"
SETTINGS_FILE=''
HELP=''

while [[ $# > 0 ]]
do
  key="$1"
  case $key in
      -h|--help)
      HELP='1'
      ;;
      -s|--settings)
      SETTINGS_FILE="$2"
      shift # past argument
      ;;
      -t|--task)
      export TASK="$2"
      shift # past argument
      ;;
      *)
      # unknown option
      ;;
  esac
  shift # past argument or value
done

if [ -n "$HELP" ]; then
  echo "Uso:"
  echo ""
  echo "    $0 [OPCOES]"
  echo ""
  echo "Opções:"
  echo ""
  echo "    -h, --help                mostra este texto."
  echo "    -s, --settings <FILE>     usa um arquivo de configuração definido por FILE."
  echo "    -t, --task <TASK>         executa a task TASK em vez de \"all\"."
  echo ""
  echo "Argumentos:"
  echo ""
  echo "    ARQUIVO: arquivo com parâmetros de instalação."
  echo ""
  echo "Os seguintes arquivos são lidos na ordem que seguem caso existam:"
  echo "    \"$SAMPLE_SETTINGS\""
  echo "    \"$DEFAULT_SETTINGS\""
  echo "    [FILE]"
  echo ""
  exit
fi

SETTINGS=("$INSTALL_ROOT/default-settings.sh" "$SAMPLE_SETTINGS")

if [ -f "$DEFAULT_SETTINGS" ]; then
  SETTINGS+=("$DEFAULT_SETTINGS")
fi

if [ -n "$SETTINGS_FILE" ]; then
  if [ -f "$SETTINGS_FILE" ]; then
    SETTINGS+=("$SETTINGS_FILE")
  else
    echo "\"$SETTINGS_FILE\" não existe."
    exit 1
  fi
fi

for S in "${SETTINGS[@]}"
do
  source "$S"
done

# redmine_installer
function programeiro_path {
  "$INSTALL_ROOT2/lib:$(_build_plugins_path "programs")"
}
export -f programeiro_path

source "$INSTALL_ROOT/environment.sh"
