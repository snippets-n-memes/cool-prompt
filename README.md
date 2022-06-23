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
5. uninstall with -u `./prompt.sh -u && source ~/.bashrc`
    - removes files added with -i
    - removes the fetch entry from your crontab
    - deletes the base `~/.cool-prompt` directory


### Usage 
1. edit the prompt from your home directory `~/.cool-prompt/config.json`
    - available colors
        - _CYAN
        - _BLUE
        - _RED
        - _GREEN
        - _BLACK
        - _YELLOW
        - _END (removes coloring)
    - `git-branch` can be used if `__git_ps1` is unavailable
    - `wf-get status` fetches the status for all workflows defined in the nearest config file
        - `.cool-prompt.json` or `.cool-prompt/config.json`
    - gitlab and github workflows are both supported

2. api request's responses are stored in /tmp and are named for each workflow's config file location and its index in the config's defined workflows array

3. Using cool-prompt without authenticating with github can trigger github api rate limiting 
    - you can verify if this is happening by checking the workflows result in /tmp
    - you can authenticate by storing a PAT in an environment var `GL_PAT` or `GH_PAT`
