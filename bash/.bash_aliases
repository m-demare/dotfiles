alias cl='clear; clear'

alias ls='ls --color=auto'

alias l='ls -CF'

alias ll='ls -alF'

alias la='ls -A'

alias work='cd ~/localwork'

alias searchDir='grep -rliF --exclude=\*.{o,class,exe,mp3,mp4}' # Usage: `searchDir 'pattern' dir`

alias cp='cp -i'

alias op='xdg-open '

alias path='tr ":" "\n"<<<$PATH | sort'

alias sudo='sudo '

alias please='sudo '

alias py='python3.10 '

alias al='vim ~/.bash_aliases '

alias src='. ~/.zshrc'

alias chr='google-chrome --new-window mail.google.com debmediacorp.teamwork.com/#projects/200596/tasks http://localhost:9000/ &'

alias freeswap='sudo swapoff -a; sudo swapon -a'

alias http='http-server'

alias elngrok='http-server -p 12347 & ngrok http 12347 && fg'

alias gl='git log --decorate --graph --pretty=short'

alias gti='git '    # too often

alias brc='vim ~/.bashrc'

alias zrc='vim ~/.zshrc'

if type nvim > /dev/null 2>&1; then
    # node 'n vim (this changes the window title, so I didn't want it to be that long)
    function nnvim(){
        if $did_init_nvm && [ $vim_node_version != $(\node -v) ]; then
            old_node_v="$(\node -v)"
            export PATH=${PATH//node\/$old_node_v/node/$vim_node_version}
            \nvim "$@"
            export PATH=${PATH//node\/$vim_node_version/node/$old_node_v}
        else
            \nvim "$@"
        fi
    }
    alias vim='nnvim'
    alias nvim='nnvim'
fi

# Current work specific stuff
alias p='cd ~/localwork/debPlayerWeb'

alias q='cd ~/localwork/debQ'

alias levQ='q; play debug run'

alias mo='cd ~/localwork/debQMobile/debQMobile; nvm use 9; ~/play/play "run 9001"'

alias appo='cd ~/localwork/debQAppointmentsOld; play "run 9002"'

alias appo2='cd ~/localwork/debQAppointments/backend; nvm use 14; ~/play/play "run 9002"'

alias surv='cd ~/localwork/debQSurvey; nvm use 9; ~/play/play "run 9003"'

alias wk='p; grunt debug-webkit'

alias lg='p; grunt debug-lg'

alias cleanLogs="q && find -name '*.log.zip' -delete"

function localProxy(){
    (ncat -lkv localhost $1 -c 'tee /dev/stderr | ncat -v localhost $2 | tee /dev/stderr') 2>&1 | tee -a $3
}

alias gFeature='xclip -sel clip -o | sed -Ee "/^\s*(.)* (#[0-9]+)\s*$/!d;s/(^\s*|\s*$)//g;s/\s/_/g;s/^((.)*)_(#[0-9]+)$/feature\/\3_\1/g" | xargs git co -b'

