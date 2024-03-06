if type nvim &> /dev/null; then
    export EDITOR='nvim'
    export MANPAGER='nvim +Man!'
else
    export EDITOR='vim'
fi

