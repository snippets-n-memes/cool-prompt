#!/bin/bash

OWNER="snippets-n-memes"
REPO="cool-prompt"
WF_NAME="Sample Workflow"
USER="mbmcmullen27"

url=$(curl -s -u "$USER:$PAT" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
  | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url") \
  2>&1


curl -s -H "Accept: application/vnd.github.v3+json"  $(echo $url)/runs \
  > /tmp/workflow_runs 2> $HOME/.cool-prompt/log

exit 0
