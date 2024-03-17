if type nvim &> /dev/null; then
    export EDITOR='nvim'
    export MANPAGER='nvim +Man!'
    export DIFFPROG='nvim -d'
else
    export EDITOR='vim'
fi

