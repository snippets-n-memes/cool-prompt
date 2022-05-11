<<<<<<< Updated upstream
CYAN='\033[0;36m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BLACK='\033[0;30m'
END='\e[m'
=======
alias CYAN="set-color '\033[0;36m'"
alias BLUE="set-color '\033[0;34m'"
alias RED="set-color '\033[0;31m'"
alias GREEN="set-color '\033[0;32m'"
alias BLACK="set-color '\033[0;30m'"
alias END="set-color '\e[m'"
>>>>>>> Stashed changes

function set-template() {
  PS1="$CYAN[\u: \W]$(__git_ps1 " ⇵ %s")\n$END$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ "
}

<<<<<<< Updated upstream
function status-map () {
  case "$1" in 
    success)

    exit;;
=======
function set-color() {
  echo -e "$1"
}

function conclusion-map () {
  case "$1" in 
    success)
      echo "$(GREEN)⬤$(END)"
      exit;;
    failure)
      echo "$(RED)⬤$(END)"
      exit;;
>>>>>>> Stashed changes
  esac
}

function get-attribute() {
  cat /tmp/workflow_runs | jq -r '.workflow_runs[0].$1'
}

function wf-get() {
  case "$1" in
    conclusion) 
      get-attribute "conclusion"
      exit;;
    status) 
      get-attribute "status"
      exit;;
    name)
      get-attribute "name"
  esac
}

# export PS1='$(CYAN)[\u: \W]$(__git_ps1 " ⇵ %s")\n$(END)$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ '

get-attribute "conclusion"