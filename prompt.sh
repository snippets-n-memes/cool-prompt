OPTIONS="hius:"

function Help() {
  cat <<EOF
  USAGE: 
      ./<scriptname> [-$OPTIONS]
  DESCRIPTION:
    Bash prompt configuration tool for ci/cd gurus
  OPTIONS:
    -h display this help message
    -i install 
    -u uninstall
EOF
}

function set-template() {
  case "$1" in
    LONG)
      PS1='\$(_CYAN)[\\\\u: \\\\W]\$(git-branch)\\n\$(_END)\$(wf-get name):\$(wf-get conclusion)\\n$'
      ;;
    SHORT)
      PS1='\$(_CYAN)[\\\\u: \\\\W]\$(git-branch):\$(_END)\$(wf-get conclusion)\\n\\\\$'
      ;;
  esac
  sed -i "s/\"PS1\": \"\"/\"PS1\": \"$PS1\"/" $(find-config)
}

function Init() {
  [ -d ~/.cool-prompt ] && Uninstall

  [ ! "$OWNER" ] && OWNER="snippets-n-memes"
  [ ! "$REPO" ] && REPO="cool-prompt"
  [ ! "$WF_NAME" ] && WF_NAME="Sample Workflow"
  
  mkdir ~/.cool-prompt 
  cat <<EOF > ~/.cool-prompt/config.json
{
  "OWNER": "$OWNER",
  "REPO": "$REPO",
  "WF_NAME": "$WF_NAME",
  "USER": "$USER",
  "PS1": ""
}

EOF

  . bashrc-block.sh
  set-template SHORT

  cp fetch.sh ~/.cool-prompt/
  cp bashrc-block.sh ~/.cool-prompt/

  crontab -l 2>/dev/null >/tmp/temp-crontab
  echo '* * * * * . $HOME/.bashrc; cd $PWD; bash --login $HOME/.cool-prompt/fetch.sh' >> /tmp/temp-crontab
  crontab /tmp/temp-crontab

  echo ". ~/.cool-prompt/bashrc-block.sh" >> /tmp/.bashrc
  cat ~/.bashrc >> /tmp/.bashrc
  echo 'export PS1=$(get-config PS1)' >> /tmp/.bashrc
  mv /tmp/.bashrc ~/.bashrc
}

function Uninstall() {
  sed -i '/\. ~\/.cool-prompt\/bashrc-block\.sh/d' ~/.bashrc
  sed -i '/export PS1=$(get-config PS1)/d' ~/.bashrc
  rm -rf ~/.cool-prompt/

  crontab -l | grep -v ".cool-prompt/fetch.sh" > /tmp/temp-crontab
  crontab /tmp/temp-crontab
}

function set-config() {
  cat $(find-config) | jq \
    --arg key "$1" \
    --arg value "$2" \
    '.[$key] = $value' \
  > /tmp/config.json
  
  mv /tmp/config.json $(find-config)
}

while getopts "$OPTIONS" option; do
   case "${option}" in
      h) Help ;;
      u) Uninstall ;;
      i) Init && echo ".bashrc configured" ;;
      s) set-config ${OPTARG%%=*} ${OPTARG##*=} ;;
      # edit
      # list available attributes
      ?) echo "USAGE: ./<scriptname> [-$OPTIONS]" ;;
   esac
done
