#!/bin/bash

OWNER="snippets-n-memes"
REPO="cool-prompt"
WF_NAME="Sample Workflow"
USER="mbmcmullen27"

url=$(curl -s -u "$USER:$PAT" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
  | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url")

curl -s -H "Accept: application/vnd.github.v3+json"  $(echo $url)/runs \
<<<<<<< Updated upstream
  > /tmp/workflow_runs
=======
  | jq ".workflow_runs[0].conclusion"
  # > /tmp/workflow_runs
>>>>>>> Stashed changes

exit 0