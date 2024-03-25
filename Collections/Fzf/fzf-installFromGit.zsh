#!/bin/zsh

# git clone the fzf repo and install fzf

[[ $# -eq 0 ]] && echo "pass local repo location as arg" && exit 1


git clone --depth 1 https://github.com/junegunn/fzf.git $1

${1}/install


