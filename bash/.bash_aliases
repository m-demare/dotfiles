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

alias py='python3.8 '

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
    alias vim='nvim'
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

