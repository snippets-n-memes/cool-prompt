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
}

while getopts "hi" option; do
   case "${option}" in
      h) # display Help
        Help
        exit;;
      i) # initialize environment
        Init
        exit;;
      ?)
        echo "USAGE: ./<scriptname> $OPTIONS"
        exit;;
   esac
done