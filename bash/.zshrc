HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=50000
setopt append_history       # Append lines in the order in which sessions are closed
setopt share_history        # Share between sessions
setopt hist_find_no_dups    # Don't display duplicates in search
setopt hist_ignore_all_dups # Don't save duplicates 
setopt extended_history     # Add timestamps to entries
setopt hist_ignore_space    # Don't add to hist if it starts with spc
setopt hist_reduce_blanks   # Remove extra spcs before adding to hist

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
bindkey '^[[Z' reverse-menu-complete

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

function appendPath(){
    export PATH=$PATH:$1
}

# Play
appendPath $HOME/play

# Android tools
export ANDROID_HOME=$HOME/android
appendPath $ANDROID_HOME/tools
appendPath $ANDROID_HOME/platform-tools

# Tizen
export TIZEN_STUDIO=$HOME/tizen-studio
appendPath $TIZEN_STUDIO/tools/ide/bin/

# Rust
appendPath $HOME/.cargo/bin

appendPath $HOME/.local/bin

export vim_node_version=v20.16.0
if type fnm > /dev/null 2>&1; then
    eval "$(fnm env --shell=zsh)"
fi

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

# History fuzzy search
fzf_history() {
    RES="$(fc -ln 1 -1 | fzf --tac --height=40%)"
    local ret=$?
    BUFFER=$(printf "${RES[@]//\\\\n/\\\\\\n}")
    zle vi-fetch-history -n $BUFFER
    zle end-of-line
    zle reset-prompt
    return $ret
}

autoload fzf_history
zle -N fzf_history
bindkey '^R' fzf_history

# Prevent saving some things to history
function zshaddhistory() {
  emulate -L zsh
  if ! [[ "$1" =~ "(^ |^z |^ts $)" ]] ; then
      print -sr -- "${1%%$'\n'}"
      fc -p
  else
      return 1
  fi
}

# Fix deletion
bindkey '^?' backward-delete-char
bindkey '^w' backward-delete-word
bindkey '^[[3~' delete-char
WORDCHARS='_-'

