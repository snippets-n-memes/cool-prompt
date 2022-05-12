OPTIONS="hiu"

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

function Init() {
  [ ! -d ~/.cool-prompt ] && mkdir ~/.cool-prompt
  if [ ! -f ~/.cool-prompt/config.json ]; then 
    cat <<EOF > ~/.cool-prompt/config.json
{
  "OWNER": "$OWNER",
  "REPO": "$REPO",
  "WF_NAME": "$WF_NAME",
  "USER": "$USER",
  "PS1": ""
}

EOF

    # PS1='$(CYAN)[\\\\u: \W]$(__git_ps1 " ⇵ %s")\\n$(END)$(wf-get name):$(wf-get conclusion)\\n$ '
    PS1='\$(_CYAN)[\\\\u: \\\\W]\$(__git_ps1 \\" ⇵ %s\\")\\n\$(_END)\$(wf-get name):\$(wf-get conclusion)\\n$'
    # jq ".\"PS1\" = $PS1" ~/.cool-prompt/config.json
    sed -i "s/\"PS1\": \"\"/\"PS1\": \"$PS1\"/" ~/.cool-prompt/config.json
  fi

  cp fetch.sh ~/.cool-prompt/
  crontab -l 2>/dev/null >/tmp/temp-crontab
  echo "* * * * * $HOME/.cool-prompt/fetch.sh" >> /tmp/temp-crontab
  crontab /tmp/temp-crontab

  echo -e "\n###### cool-prompt START #####\n" >> ~/.bashrc
  cat ./bashrc-block.sh >> ~/.bashrc
  echo -e "\n###### cool-prompt END #####\n" >> ~/.bashrc
}

function Uninstall() {
  crontab -l | grep -v ".cool-prompt/fetch.sh" > /tmp/temp-crontab
  crontab /tmp/temp-crontab

  perl -0777pe 's/\n#+ cool-prompt START #{5}.*#+ cool-prompt END #+\n//s' -i ~/.bashrc
}

function set-template() {
  PS1="$CYAN[\u: \W]$(__git_ps1 " ⇵ %s")\n$END$(wf-get name)->$(wf-get status):$(wf-get conclusion)\n$ "
}

while getopts "$OPTIONS" option; do
   case "${option}" in
      h) # display Help
        Help
        exit;;
      i) # initialize environment
        Init
        exit;;
      u) # uninstall environment
        Uninstall
        exit;;
      # authenticate
      # edit prompt
      # list available attributes
      ?)
        echo "USAGE: ./<scriptname> $OPTIONS"
        exit;;
   esac
done
