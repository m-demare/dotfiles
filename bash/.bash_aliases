alias cl='clear; clear'

alias ls='ls --color=auto'

alias grep='grep --color=auto'

alias fgrep='fgrep --color=auto'

alias egrep='egrep --color=auto'

alias l='ls -CF'

alias ll='ls -alF'

alias la='ls -A'

alias history='history 1'

alias cp='cp -i'

alias less='less --ignore-case'

alias op='xdg-open '

alias path='tr ":" "\n"<<<$PATH'

alias sudo='sudo '

alias py='python3 '

alias al='$EDITOR ~/.bash_aliases '

alias freeswap='sudo swapoff -a; sudo swapon -a'

alias http='http-server'

alias elngrok='http-server -p 12347 & ngrok http 12347 && fg'

alias brc='$EDITOR ~/.bashrc'

alias zrc='$EDITOR ~/.zshrc'

alias -- -='cd -'

alias ...=../..

alias ....=../../..

alias .....=../../../..

alias wiki='wiki-tui'

function localProxy(){
    (ncat -lkv localhost $1 -c 'tee /dev/stderr | ncat -v localhost $2 | tee /dev/stderr') 2>&1 | tee -a $3
}

function mvtmp(){
    DIR=`mktemp -d -t "mvtmp.XXXX"` && \
    mv "$@" $DIR && \
    cd $DIR
}

if type nvim > /dev/null 2>&1; then
    if type fnm > /dev/null 2>&1; then
        # node 'n vim (this changes the window title, so I didn't want it to be that long)
        function nnvim(){
            old_node_v="$(fnm current)"
            fnm use $vim_node_version > /dev/null
            \nvim "$@"
            fnm use $old_node_v > /dev/null
        }
        alias nvim='nnvim'
        alias v='nnvim'
    fi
fi

# Git {{{
alias gl='git log --decorate --graph --pretty=short'

alias glo='git log --decorate --graph --oneline'

alias gti='git '    # too often

alias g='git '

gMergesOf () {
    git log --merges --ancestry-path --oneline $1..origin | tail
}

alias gco='git checkout'

alias gst='git status'

alias gd='git diff'
# }}}

# Tmux {{{
alias ta='tmux attach -t'

alias tl='tmux list-sessions'

alias ts='tmux new-session -s'
# }}}

# Current work specific stuff {{{
alias p='cd ~/localwork/debPlayerWeb'

alias q='cd ~/localwork/debQ'

alias levQ='q; fnm use 9; play debug run'

alias mo='cd ~/localwork/debQMobile/debQMobile; fnm use 9; ~/play/play "run 9001"'

alias appo='cd ~/localwork/debQAppointments/backend; fnm use 20; ~/play/play "run 9002"'

alias surv='cd ~/localwork/debQSurvey; fnm use 9; ~/play/play "run 9003"'

alias wk='p; grunt debug-webkit'

alias lg='p; grunt debug-lg'

alias cleanLogs="q && find -name '*.log.zip' -delete"

alias gFeature='xclip -sel clip -o | sed -Ee "/^\s*(.)* (#[0-9]+)\s*$/!d;s/(^\s*|\s*$)//g;s/\s/_/g;s/^((.)*)_(#[0-9]+)$/feature\/\3_\1/g" | xargs git co -b'

alias wifiEnable='sudo systemctl restart iwd.service && sudo dhcpcd wlan0 --nohook mtu && sudo dhcpcd wlan0 --nohook mtu'

alias fixDbeaver='echo "-vm\n/usr/lib/jvm/java-22-openjdk/bin" | cat - /usr/share/dbeaver/dbeaver.ini | sudo tee /usr/share/dbeaver/dbeaver.ini'
# }}}
