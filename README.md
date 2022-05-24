# cool-prompt

Github workflow status in your terminal prompt with bash 

### Install Directions
```sh
./prompt.sh -i && . ~/.bashrc
```
1. clone repo and run `./prompt.sh -i` to setup required configuration files and directories
    - adds a directory `$HOME/.cool-prompt`
    - adds an entry to your crontab
    - adds some functions to your `.bashrc`
    - overrides your PS1
2. Make sure your crontab shell is set to bash
    - if you're using WSL cron needs to be configured to autostart
3. Source your .bashrc file
4. set prompt using the new functions
