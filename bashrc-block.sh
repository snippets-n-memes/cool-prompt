#!/bin/bash

alias _CYAN="echo -e '\033[1;36m'"
alias _BLUE="echo -e '\033[0;34m'"
alias _RED="echo -e '\033[1;31m'"
alias _GREEN="echo -e '\033[0;32m'"
alias _BLACK="echo -e '\033[0;30m'"
alias _YELLOW="echo -e '\033[1;33m'"
alias _END="echo -e '\e[m'"

function find-config() {
  if [ -f ".cool-prompt/config.json" ]; then
    echo "${PWD%/}/.cool-prompt/config.json"
  elif [ "$PWD" = / ]; then
    echo $HOME/.cool-prompt/config.json 
  else
    (cd .. && find-config)
  fi
}

function config-name() {
  find-config \
    | awk -F'/.cool-prompt' '{print $1}' \
    | tr '/' '_'
}

function get-config() {
  DIR=$(find-config)
  [ "$1" = "PS1" ] && DIR=$HOME/.cool-prompt/config.json
  jq -r ".$1" $DIR 
}

function set-config() {
  cat $(find-config) | jq \
    --arg key "$1" \
    --arg value "$2" \
    '.[$key] = $value' \
  > /tmp/config.json
  
  mv /tmp/config.json $(find-config)
}

function git-branch() {
  BRANCH=$(git branch --show-current 2> /dev/null)
  [ "${BRANCH}" ] && echo "$(_YELLOW)⇵ $BRANCH$(_CYAN)"
}

function conclusion-map () {
  case $1 in 
    success)
      echo "$(_GREEN)⬤$(_END)"
      exit;;
    failure | failed)
      echo "$(_RED)⬤$(_END)"
      exit;;
    *)
      echo "$(_YELLOW)⬤$(_END)"
      exit;;
  esac
}

function get-attribute-gh() {
  jq -r ".workflow_runs[0].$1" "/tmp/$(config-name)_workflow_runs" 2> /dev/null
}

function get-attribute-gl() {
  jq -r ".[0].$1" "/tmp/$(config-name)_workflow_runs" 2> /dev/null
}

function get-attribute() {
  WF_HOST=$(get-config HOST)
  case "$WF_HOST" in
    github) get-attribute-gh $1 ;;
    gitlab) get-attribute-gl $1 ;;
  esac
}

function wf-get() {
  case "$1" in
    status)
      WF_HOST="$(get-config HOST)" 
      [[ "$WF_HOST" = "github" ]] \
        && conclusion-map $(get-attribute-gh "conclusion") \
        || conclusion-map $(get-attribute-gl "status")
      exit;;
    *)
      get-attribute $1
      exit;;
  esac
}
