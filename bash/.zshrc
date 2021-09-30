export ZSH="/home/matias/.oh-my-zsh"

ZSH_THEME="macovsky"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git zsh-z thefuck)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Add default node to path
default_node=~/.nvm/versions/node/v14.18.0/bin
export PATH=$default_node:$PATH

# Default nvm script is too slow
# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once by checking whether __init_nvm is a function.
# In bash use type -t instead of whence -w
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack' 'play' 'http-server')
  function __init_nvm() {
    export PATH=`echo -n "$(echo $PATH | tr ':' '\n' | grep -v "$default_node")" | tr '\n' ':'` # remove default node
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='echo "Initializing nvm" && __init_nvm && '$i; done
fi


# Play
export PATH=$PATH:$HOME/play

# Android tools
export ANDROID_HOME=$HOME/android
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools


# Tizen
TIZEN_STUDIO=$HOME/tizen-studio
export PATH=$PATH:$TIZEN_STUDIO/tools/ide/bin/

# Colors
        RED="\033[0;31m"
     YELLOW="\033[1;33m"
      GREEN="\033[0;32m"
       BLUE="\033[1;34m"
     PWD_BLUE="\033[00m"
  LIGHT_RED="\033[1;31m"
LIGHT_GREEN="\033[1;32m"
       CYAN="\033[0;36m"
 LIGHT_CYAN="\033[1;36m"
      WHITE="\033[1;37m"
 LIGHT_GRAY="\033[0;37m"
 COLOR_NONE="\e[0m"


# SQLServer
export PATH="$PATH:/opt/mssql-tools/bin"

export PATH=$PATH:$HOME/ngrok
export PATH=$PATH:$HOME/bochs/bin

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

