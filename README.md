# cool-prompt

Github workflow status in your terminal prompt with pure bash 

### Install Directions
```sh
./prompt.sh -i && . ~/.bashrc
```
1. clone repo and run `./prompt.sh -i` to setup required configuration files and directories
    - this creates a directory `$HOME/.cool-prompt`
    - adds an entry to your crontab
    - adds some functions to your `.bashrc`
2. Make sure your crontab shell is set to bash
3. Source your .bashrc file
4. if you're using WSL cron needs to be configured to autostart
5. set prompt using the new functions

- old model ps1
```sh
PS1='\[\033[01;32m\]🖫Kube-Space\[\033[00m\]\[\033[01;34m\]\w\[\033[01;32m\] ⮁:\[\033[01;33m\]$(gitbranch)\[\033[01;32m\] ♲:\[\033[01;33m\]$ENV `if [ "$(plstatus 2)" = succeeded ]; then printf "\[\033[01;32m\]$(plstatus 0)"; elif [ "$(plstatus 1)" = inProgress ]; then printf "$(plstatus 0)"; else printf "\[\033[31m\]$(plstatus 0)"; fi;`\[\033[00m\]\n$ '
```

- new model ps1
```sh
PS1='$(_CYAN)[\u: \W]$(__git_ps1 " ⇵ %s")\n$(_END)$(wf-get name):$(wf-get conclusion)\n$ '
```
