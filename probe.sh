#!/bin/bash

touch "$HOME/.cool-prompt/log-$$"
lsof -au $USER -d cwd -c bash -PF n -w \
    | grep -Po "(?<=n).*" \
    | uniq > "$HOME/.cool-prompt/log-$$"
