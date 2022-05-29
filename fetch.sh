#!/bin/bash

function github-workflow() {
  log "github-workflow called"

  OWNER=$(get-config-i $1 OWNER)
  REPO=$(get-config-i $1 REPO)
  WF_NAME=$(get-config-i $1 WF_NAME)
  URL=$(get-config-i $1 URL)

  if [ -z ${URL} ]; then
    log "URL unset, fetching"
    URL=$(curl -s -u ":$GH_PAT" -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/$OWNER/$REPO/actions/workflows \
      | jq -r ".workflows[] | select(.name == \"$WF_NAME\") | .url" \
      2> $HOME/.cool-prompt/log) 
    set-config URL $URL $1
    log "URL found $URL for $WF_NAME"
  fi

  curl -s -u ":$GH_PAT" -H "Accept: application/vnd.github.v3+json"  $URL/runs \
    2> $HOME/.cool-prompt/log \
    1> "/tmp/$(config-name $1)"
}

function gitlab-pipeline() {
  log "gitlab-workflow called"

  PROJECT_ID=$(get-config-i $1 PROJECT_ID)

  curl -s -H "PRIVATE-TOKEN: $GL_PAT" \
    "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines" \
    2> $HOME/.cool-prompt/log \
    1> "/tmp/$(config-name $1)" 
}

function config-paths() {
  log "config-paths called"

  lsof -au $USER -d cwd -c bash -F n -w \
    | grep -Po "(?<=n).*" \
    | sort \
    | uniq 
}

log "fetch.sh called"  
config-paths > ~/.cool-prompt/paths
touch ~/.cool-prompt/wf_hosts
touch ~/.cool-prompt/wf_dirs
while read dir; do
    log "config directory $dir found"  
    cd $dir
    echo $dir >> ~/.cool-prompt/wf_dirs
    WF_HOST=($(get-config HOST))

    for i in "${!WF_HOST[@]}"; do
      echo "$(config-name $i)" >> ~/.cool-prompt/wf_hosts
      host=${WF_HOST[$i]}
      log "Dispatch $host workflow function"
      case ${host} in
        github) github-workflow $i ;;
        gitlab) gitlab-pipeline $i ;;
        *) echo "Unmatched ${host} : $dir [$i]" >> ~/.cool-prompt/log ;;
      esac
    done
done < <(tr ' ' '\n' < ~/.cool-prompt/paths)
# rm ~/.cool-prompt/paths
