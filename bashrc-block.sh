alias _CYAN="set-color '\033[0;36m'"
alias _BLUE="set-color '\033[0;34m'"
alias _RED="set-color '\033[0;31m'"
alias _GREEN="set-color '\033[0;32m'"
alias _BLACK="set-color '\033[0;30m'"
alias _YELLOW="set-color '\033[0;33m'"
alias _END="set-color '\e[m'"

function set-template() {
  PS1="$CYAN[\u: \W]$(__git_ps1 " ⇵ %s")\n$END$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ "
}

function set-color() {
  echo -e "$1"
}

function conclusion-map () {
  case "$1" in 
    success)
      echo "$(_GREEN)⬤$(_END)"
      exit;;
    failure)
      echo "$(_RED)⬤$(_END)"
      exit;;
    *)
      echo "$(_YELLOW)⬤$(_END)"
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

export PS1='$(CYAN)[\u: \W]$(__git_ps1 " ⇵ %s")\n$(END)$(wf-get name):$(wf-get conclusion)\n$ '