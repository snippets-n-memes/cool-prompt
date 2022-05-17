#!/bin/bash

OWNER=$(get-config OWNER)
REPO=$(get-config REPO)
WF_NAME=$(get-config WF_NAME)
USER=$(get-config USER)

url=$(curl -s -u "$USER:$PAT" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
  | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url") 

curl -s -H "Accept: application/vnd.github.v3+json"  $(echo $url)/runs \
  > /tmp/workflow_runs 2> $HOME/.cool-prompt/log

exit 0
