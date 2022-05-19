#!/bin/bash

function github-workflow() {
  OWNER=$(get-config OWNER)
  REPO=$(get-config REPO)
  WF_NAME=$(get-config WF_NAME)
  USER=$(get-config USER)

  url=$(curl -s -u "$USER:$PAT" -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
    | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url") 

  curl -s -H "Accept: application/vnd.github.v3+json"  $(echo $url)/runs \
    > "/tmp/$(config-name)_workflow_runs" \
    2> $HOME/.cool-prompt/log
}

function gitlab-pipeline() {
  PROJECT_ID=$(get-config PROJECT_ID)

  curl -s -H "PRIVATE-TOKEN: $PAT" \
    "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines" \
    > "/tmp/$(config-name)_workflow_runs" \
    2> $HOME/.cool-prompt/log
}

function config-paths() {
  lsof -au $USER -d cwd -c bash -F n -w \
    | grep -Po "(?<=n).*" \
    | sort \
    | uniq 
}

config-paths > ~/.cool-prompt/paths
while read dir; do
    cd $dir
    WF_HOST=$(jq -r '.HOST' $(find-config))
    case $WF_HOST in
      github) github-workflow ;;
      gitlab) gitlab-pipeline ;;
      *) echo "Unmatched $WF_HOST : $dir" >> ~/.cool-prompt/log ;;
    esac
done < <(tr ' ' '\n' < ~/.cool-prompt/paths)
rm ~/.cool-prompt/paths
