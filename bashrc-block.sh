CYAN='\033[0;36m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BLACK='\033[0;30m'


function print-status() {
  case "$1" in
    conclusion) 
      grep /tmp/workflow_status -oP "(?<=CONCLUSION=).*$"
      exit;;
    status) 
      grep /tmp/workflow_status -oP "(?<=STATUS=).*$"
      exit;;
  esac
}

function status-template() {

}