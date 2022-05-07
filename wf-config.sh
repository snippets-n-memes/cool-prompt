OPTIONS="[-hi]"

function Help() {
  cat <<EOF
  USAGE: 
      ./<scriptname> $OPTIONS
  DESCRIPTION:
    Bash prompt configuration tool for ci/cd gurus
  OPTIONS:
    -h display this help message
EOF
}

function Init() {
  [ ! -d ~/.cool-prompt ] && mkdir ~/.cool-prompt
  if [ ! -f ~/.cool-prompt/config ]; then 
    cat <<EOF > ~/.cool-prompt/config
OWNER=$OWNER
REPO=$REPO
WF_NAME=$WF_NAME
USER=$USER
EOF
  fi

  cp fetch.sh ~/.cool-prompt/
  crontab -l 2>/dev/null >/tmp/temp-crontab
  echo "* * * * * $HOME/.cool-prompt/fetch.sh" >> /tmp/temp-crontab
  crontab /tmp/temp-crontab

  echo -e "\n###### cool-prompt START #####" >> ~/.bashrc
  cat ./bashrc-block.sh >> ~/.bashrc
  echo -e "\n###### cool-prompt END #####" >> ~/.bashrc
}

while getopts "hi" option; do
   case "${option}" in
      h) # display Help
        Help
        exit;;
      i) # initialize environment
        Init
        exit;;
      # authenticate
      # edit prompt
      # list available attributes
      ?)
        echo "USAGE: ./<scriptname> $OPTIONS"
        exit;;
   esac
done