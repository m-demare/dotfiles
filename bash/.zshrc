HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
setopt appendhistory
setopt sharehistory
setopt hist_find_no_dups

fpath=(~/.config/zsh-z $fpath)
autoload -U compinit && compinit
# https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

setopt autocd

source $HOME/.config/zsh-z/zsh-z.plugin.zsh

# Prompt {{{

# Autoload zsh's `add-zsh-hook` and `vcs_info` functions
# (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info

# Set prompt substitution so we can use vcs_info_msg_0_
setopt prompt_subst

# Run the `vcs_info` hook to grab git info before displaying the prompt
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%F{yellow}‹%b%u› %f'
# Format when the repo is in an action (merge, rebase, etc)
zstyle ':vcs_info:git*' actionformats '%F{14}‹%b%u› %f'
zstyle ':vcs_info:git*' unstagedstr '*'
# Enable %u and %c (unstaged/staged changes) to work
zstyle ':vcs_info:*:*' check-for-changes true

# Directory % [git status]
PROMPT='%F{green}%~%f ${vcs_info_msg_0_}%f%B%#%b '

# [↵ $?]
RPROMPT="%(?..%F{red}%? ↵%f)"

# }}}


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


# Vi mode (copied from https://superuser.com/a/1253211) {{{
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
# }}}

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M vicmd "^P" up-line-or-beginning-search
bindkey -M viins "^P" up-line-or-beginning-search
bindkey -M vicmd "^N" down-line-or-beginning-search
bindkey -M viins "^N" down-line-or-beginning-search

