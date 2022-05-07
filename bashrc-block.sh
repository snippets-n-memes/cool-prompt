CYAN='\033[0;36m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BLACK='\033[0;30m'
END='\e[m'

function get-stat() {
  grep -oP "(?<=$1=).*$" /tmp/workflow_status
}

function get-attribute() {
  cat /tmp/workflow_runs | jq -r '.workflow_runs[0].$1'
}

function wf-get() {
  case "$1" in
    conclusion) 
      get-stat "CONCLUSION"
      exit;;
    status) 
      get-stat "STATUS"
      exit;;
    name)
      get-attribute "name"
  esac
}

print-status conclusion