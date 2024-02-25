export ZSH="/home/matias/.oh-my-zsh"

ZSH_THEME="macovsky"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git zsh-z tmux)

source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8

if type nvim &> /dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# ssh agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

export PATH=/bin:/usr/bin:/usr/ucb:/usr/local/bin

# Play
export PATH=$PATH:$HOME/play

# Ruby
export PATH=$PATH:~/.local/share/gem/ruby/3.0.0/bin

# Android tools
export ANDROID_HOME=$HOME/android
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools


# Tizen
TIZEN_STUDIO=$HOME/tizen-studio
export PATH=$PATH:$TIZEN_STUDIO/tools/ide/bin/

export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:$HOME/.cargo/bin

export vim_node_version=v20.5.1
eval "$(fnm env --shell=zsh)"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# Vi mode (copied from https://superuser.com/a/1253211)
bindkey -v
DEFAULT_VI_MODE=viins
KEYTIMEOUT=1
__set_cursor() {
    local style
    case $1 in
        reset) style=0;;
        blink-block) style=1;;
        block) style=2;;
        blink-underline) style=3;;
        underline) style=4;;
        blink-vertical-line) style=5;;
        vertical-line) style=6;;
    esac

    [ $style -ge 0 ] && print -n -- "\e[${style} q"
}

__set_vi_mode_cursor() {
    case $KEYMAP in
        vicmd)
          __set_cursor block
          ;;
        main|viins)
          __set_cursor vertical-line
          ;;
    esac
}

__get_vi_mode() {
    local mode
    case $KEYMAP in
        vicmd)
          mode=NORMAL
          ;;
        main|viins)
          mode=INSERT
          ;;
    esac
    print -n -- $mode
}

zle-keymap-select() {
    __set_vi_mode_cursor
    zle reset-prompt
}

zle-line-init() {
    zle -K $DEFAULT_VI_MODE
}

zle -N zle-line-init
zle -N zle-keymap-select

# allows you to open the in-progress command inside of $EDITOR
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line
zle -N edit-command-line

bindkey -M vicmd "^P" up-line-or-beginning-search
bindkey -M viins "^P" up-line-or-beginning-search
bindkey -M vicmd "^N" down-line-or-beginning-search
bindkey -M viins "^N" down-line-or-beginning-search
bindkey "^W" vi-backward-kill-word

