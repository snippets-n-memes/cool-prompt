alias CYAN="set-color '\033[0;36m'"
alias BLUE="set-color '\033[0;34m'"
alias RED="set-color '\033[0;31m'"
alias GREEN="set-color '\033[0;32m'"
alias BLACK="set-color '\033[0;30m'"
alias END="set-color '\e[m'"

function set-template() {
  PS1="$CYAN[\u: \W]$(__git_ps1 " ⇵ %s")\n$END$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ "
}

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

export PS1='$(CYAN)[\u: \W]$(__git_ps1 " ⇵ %s")\n$(END)$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ '