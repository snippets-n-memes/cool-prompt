#!/bin/bash

OWNER="mbmcmullen27"
REPO="raspberry-spi"
WF_NAME="Build All"
USER="mbmcmullen27"

url=$(curl -s -u "$USER:$PAT" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
  | jq ".workflows[] | select(.name == \"$WF_NAME\") | .url") \

curl -s -H "Accept: application/vnd.github.v3+json"  $(echo $url | tr -d '"')/runs \
  > /tmp/workflow_runs

if [ ! -f /tmp/workflow_status ]; then 
  cat <<EOF > /tmp/workflow_status
STATUS=
CONCLUSION=    
EOF
fi

STATUS=$(cat /tmp/workflow_runs | jq -r '.workflow_runs[0].status')
CONCLUSION=$(cat /tmp/workflow_runs | jq -r '.workflow_runs[0].conclusion')

sed -i "s/STATUS=.*/STATUS=$STATUS/" /tmp/workflow_status
sed -i "s/CONCLUSION=.*/CONCLUSION=$CONCLUSION/" /tmp/workflow_status

exit 0