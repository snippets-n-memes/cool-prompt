#!/bin/bash

alias _CYAN="echo -e '\033[1;36m'"
alias _BLUE="echo -e '\033[0;34m'"
alias _RED="echo -e '\033[1;31m'"
alias _GREEN="echo -e '\033[0;32m'"
alias _BLACK="echo -e '\033[0;30m'"
alias _YELLOW="echo -e '\033[1;33m'"
alias _END="echo -e '\e[m'"

function log() {
  echo "[$(date +\"%T\")] $1" >> ~/.cool-prompt/execution-log
}

function find-config() {
  if [ -f ".cool-prompt/config.json" ]; then
    echo "${PWD%/}/.cool-prompt/config.json"
  elif [ -f ".cool-prompt.json" ]; then
    echo "${PWD%/}/.cool-prompt.json"
  elif [ "$PWD" = / ]; then
    echo $HOME/.cool-prompt/config.json 
  else
    (cd .. && find-config)
  fi
}

function config-name() {
  CONFIG_PATH=$(find-config \
    | awk -F'/.cool-prompt' '{print $1}' \
    | tr '/' '_')

  echo "${CONFIG_PATH}_$1"
}

function get-config() {
  DIR=$(find-config)
  if [ "$1" = "PS1" ]; then
    DIR=$HOME/.cool-prompt/config.json
    jq -r ".$1" $DIR 
  elif [ "$1" != "workflows" ]; then
    jq -r ".workflows[].$1" $DIR
  else 
    jq -r ".$1" $DIR 
  fi
}

function get-config-i() {
  let "i = $1 + 1"
  get-config $2 | sed -n "${i}p" 
}

function set-config() {
  cat $(find-config) | jq \
    --arg key "$1" \
    --arg value "$2" \
    --argjson index "$3" \
    '.workflows[$index][$key] = $value' \
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
      echo -n "$(_GREEN)⬤$(_END)" ;;
    failure | failed) 
      echo -n "$(_RED)⬤$(_END)" ;;
    *) 
      echo -n "$(_YELLOW)⬤$(_END)" ;;
  esac
}

function get-attribute-gh() {
  jq -r ".workflow_runs[0].$1" "/tmp/$(config-name $2)" 2> /dev/null
}

function get-attribute-gl() {
  jq -r ".[0].$1" "/tmp/$(config-name $2)" 2> /dev/null
}

function get-attribute() {
  WF_HOST=$(get-config-i $1 HOST)
  case "${WF_HOST[0]}" in
    github) get-attribute-gh $2 ;;
    gitlab) get-attribute-gl $2 ;;
  esac
}

function wf-get() {
  case "$1" in
    status)
      WF_HOST=($(get-config HOST))
      for i in ${!WF_HOST[@]}; do
        cat "/tmp/$(config-name $i)_last_status"
      done
      exit;;
    *)
      get-attribute $1
      exit;;
  esac
}

function wf-test() {
  WF_HOST=($(get-config HOST))
  for i in ${!WF_HOST[@]}; do
    get-config-i $i WF_NAME
    # [[ "${WF_HOST[$i]}" = "github" ]] \
    #   && conclusion-map $(get-attribute-gh "conclusion" $i) \
    #   || conclusion-map $(get-attribute-gl "status" $i)
  done
}
