CYAN='\033[0;36m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLACK='\033[0;30m'
END='\e[m'

function set-template() {
  PS1="$CYAN[\u: \W]$(__git_ps1 " ⇵ %s")\n$END$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ "
}

function conclusion-map () {
  case "$1" in 
    success)
      echo "$GREEN⬤$END"
      exit;;
    failure)
      echo "$RED⬤$END"
      exit;;
  esac
}

function get-attribute() {
  cat /tmp/workflow_runs | jq -r ".workflow_runs[0].$1"
}

function wf-get() {
  case "$1" in
    conclusion) 
      conclusion-map $(get-attribute "conclusion")
      exit;;
    status) 
      get-attribute "status"
      exit;;
    name)
      get-attribute "name"
  esac
}
