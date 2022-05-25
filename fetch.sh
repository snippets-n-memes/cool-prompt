#!/bin/bash

function github-workflow() {
  OWNER=$(get-config-i $1 OWNER)
  REPO=$(get-config-i $1 REPO)
  WF_NAME=$(get-config-i $1 WF_NAME)
  URL=$(get-config-i $1 URL)

  if [[ "${URL:-null}" = "null" ]]; then
    URL=$(curl -s -u ":$GH_PAT" -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
      | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url" \
      2> $HOME/.cool-prompt/log) 
    set-config "URL" "$URL"
  fi

  curl -s -u ":$GH_PAT" -H "Accept: application/vnd.github.v3+json"  $URL/runs \
    2> $HOME/.cool-prompt/log \
    1> "/tmp/$(config-name)_workflow_runs"
}

function gitlab-pipeline() {
  PROJECT_ID=$(get-config-i $1 PROJECT_ID)

  curl -s -H "PRIVATE-TOKEN: $GL_PAT" \
    "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines" \
    2> $HOME/.cool-prompt/log \
    1> "/tmp/$(config-name)_workflow_runs" 
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
    WF_HOST=($(get-config HOST))
    for i in ${!WF_HOST[@]}; do
      case ${WF_HOST[$i]} in
        github) github-workflow $i ;;
        gitlab) gitlab-pipeline $i ;;
        *) echo "Unmatched $WF_HOST : $dir" >> ~/.cool-prompt/log ;;
      esac
    done
done < <(tr ' ' '\n' < ~/.cool-prompt/paths)
rm ~/.cool-prompt/paths
