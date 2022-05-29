OPTIONS="hius:a"

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
    -s set "key=value" in nearest config file
EOF
}

function set-template() {
  case "$1" in
    LONG)
      PS1='\$(_CYAN)[\\\\u: \\\\W]\$(git-branch)\\n\$(_END)\$(wf-get name):\$(wf-get conclusion)\\n$'
      ;;
    SHORT)
      PS1='\$(_CYAN)[\\\\u: \\\\W]\$(git-branch):\$(_END)\$(wf-get status)\\n\\\\$'
      ;;
  esac
  sed -i -E "s/(\"PS1\":) \"\"/\1 \"$PS1\"/" $HOME/.cool-prompt/config.json
}

function Init() {
  [ -d ~/.cool-prompt ] && Uninstall

  [ ! "$OWNER" ] && OWNER="snippets-n-memes"
  [ ! "$REPO" ] && REPO="cool-prompt"
  [ ! "$WF_NAME" ] && WF_NAME="Sample Workflow"
  [ ! "$WF_HOST" ] && WF_HOST="github"
  # [ ! "$PROJECT_ID" ] && PROJECT_ID="36257401"
  
  mkdir ~/.cool-prompt 
  touch ~/.cool-prompt/execution-log
  cat <<EOF > ~/.cool-prompt/config.json
{
  "workflows": [
    {
      "OWNER": "$OWNER",
      "REPO": "$REPO",
      "WF_NAME": "$WF_NAME",
      "HOST": "$WF_HOST",
      "URL": ""
    }
  ],
  "PS1": ""
}

EOF

  . bashrc-functions.sh
  set-template SHORT

  cp fetch.sh ~/.cool-prompt/
  cp bashrc-functions.sh ~/.cool-prompt/

  crontab -l 2>/dev/null >/tmp/temp-crontab
  echo '* * * * * . $HOME/.bashrc; bash --login $HOME/.cool-prompt/fetch.sh' >> /tmp/temp-crontab
  crontab /tmp/temp-crontab
  rm /tmp/temp-crontab

  echo "source ~/.cool-prompt/bashrc-functions.sh" >> /tmp/.bashrc
  cat ~/.bashrc >> /tmp/.bashrc
  echo 'export PS1=$(get-config PS1)' >> /tmp/.bashrc
  mv /tmp/.bashrc ~/.bashrc
}

function Uninstall() {
  sed -i '/source ~\/.cool-prompt\/bashrc-functions\.sh/d' ~/.bashrc
  sed -i '/export PS1=$(get-config PS1)/d' ~/.bashrc
  rm -rf ~/.cool-prompt/

  crontab -l | grep -v ".cool-prompt/fetch.sh" > /tmp/temp-crontab
  crontab /tmp/temp-crontab
  rm /tmp/temp-crontab
}

function add-config() {
  mkdir .cool-prompt 
  cat <<EOF > .cool-prompt/config.json
{
  "workflows": [
    {
      "OWNER": "$OWNER",
      "REPO": "$REPO",
      "WF_NAME": "$WF_NAME",
      "HOST": "$WF_HOST",
      "URL": ""
    }
  ]
}

EOF
}

while getopts "$OPTIONS" option; do
   case "${option}" in
      h) Help ;;
      u) Uninstall ;;
      i) Init && echo ".bashrc configured" ;;
      s) set-config ${OPTARG%%=*} ${OPTARG##*=} ;;
      a) add-config ;;
      ?) echo "USAGE: ./<scriptname> [-$OPTIONS]" ;;
   esac
done
