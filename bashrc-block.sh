#!/bin/bash

alias _CYAN="echo -e '\033[1;36m'"
alias _BLUE="echo -e '\033[0;34m'"
alias _RED="echo -e '\033[1;31m'"
alias _GREEN="echo -e '\033[0;32m'"
alias _BLACK="echo -e '\033[0;30m'"
alias _YELLOW="echo -e '\033[1;33m'"
alias _END="echo -e '\e[m'"


function update-pwd() {
  for i in $(ps h --ppid $(pgrep crond)); do
    [[ $$ = $i ]] && exit 1
  done
  DIR=$(pwd)
  sed -E -i "s|(\"PWD\":) \"[^\"]*\"|\1 \"$DIR\"|" $HOME/.cool-prompt/config.json
}

update-pwd

function find-config() {
  if [ -f ".cool-prompt/config.json" ]; then
    echo "${PWD%/}/.cool-prompt/config.json"
  elif [ "$PWD" = / ]; then
    echo $HOME/.cool-prompt/config.json 
  else
    (cd .. && find-config)
  fi
}

function get-config() {
  jq -r ".$1" $(find-config 2> $HOME/.cool-prompt/log) 
}

function git-branch() {
  BRANCH=$(git branch --show-current 2> /dev/null)
  [ "${BRANCH}" ] && echo "$(_YELLOW)⇵ $BRANCH$(_CYAN)"
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
  jq -r ".workflow_runs[0].$1" /tmp/workflow_runs 2> /dev/null
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
      exit;;
  esac
}
