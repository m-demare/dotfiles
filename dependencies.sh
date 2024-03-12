#!/bin/bash

mkdir -p $HOME/localwork/
platform=$(uname)

if [[ $platform =~ "Linux" ]]; then

    if command -v pacman &> /dev/null
    then
        INSTALL="sudo pacman --noconfirm -Syu"
        EXTRA_PACKAGES="gdb-dashboard rustup rust-analyzer alacritty bottom fd unarchiver"
    else
        echo "Updating repos"
        sudo apt-get update >> /dev/null
        INSTALL="sudo apt-get -y install"
        EXTRA_PACKAGES="cargo fd-find unar"
    fi

    install_packages(){
        echo "Installing $1"
        $INSTALL $1
    }

    install_packages "git curl zsh ripgrep tmux zathura gdb python neovim fzf stow $EXTRA_PACKAGES"

    # use zsh
    sudo chsh $USER -s $(which zsh) &&
        echo "Changed default shell to zsh"

    # neovim
    echo "Cloning neovim"
    git clone https://github.com/neovim/neovim $HOME/localwork/neovim

    echo "Cloning zsh-z"
    mkdir -p $HOME/.config
    git clone https://github.com/agkozak/zsh-z $HOME/.config/zsh-z

    # rust
    if command -v pacman &> /dev/null
    then
        rustup toolchain install nightly
        rustup toolchain install stable
        rustup default nightly
    else
        cargo install alacritty bottom
    fi
    cargo install fnm samply flamegraph cargo-valgrind wiki-tui yazi

    fnm install v20.5.1

elif [[ $platform =~ "MINGW" ]]; then
    # Windows
    echo "This should be run using git bash"
    cmd <<< "mklink /D %HOMEPATH%\\AppData\\Local\\nvim %HOMEPATH%\\.dotfiles\\vim\\.config\\nvim\\"
    mkdir -p $HOME/.config/vim
    cmd <<< "mklink %HOMEPATH%\\.config\\vim\\globals.vim %HOMEPATH%\\.dotfiles\\vim\\.config\\vim\\globals.vim"
    cmd <<< "mklink %HOMEPATH%\\.vimrc %HOMEPATH%\\.dotfiles\\vim\\.vimrc"
    cmd <<< "mklink %HOMEPATH%\\.bashrc %HOMEPATH%\\.dotfiles\\bash\\.bashrc"
    cmd <<< "mklink %HOMEPATH%\\.bash_aliases %HOMEPATH%\\.dotfiles\\bash\\.bash_aliases"
    cmd <<< "mklink %HOMEPATH%\\.gitconfig %HOMEPATH%\\.dotfiles\\git\\.gitconfig"
    echo "Created symlink for nvim settings"
fi

git clone https://github.com/m-demare/dotfiles.git $HOME/.dotfiles

exit 0

