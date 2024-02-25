#!/bin/bash

platform=$(uname)

if [[ $platform =~ "Linux" ]]; then

    if command -v pacman &> /dev/null
    then
        INSTALL="sudo pacman --noconfirm -Syu"
        EXTRA_PACKAGES="gdb-dashboard rustup rust-analyzer alacritty bottom fnm"
    else
        echo "Updating repos"
        sudo apt-get update >> /dev/null
        INSTALL="sudo apt-get -y install"
        EXTRA_PACKAGES="cargo"
    fi

    install_packages(){
        echo "Installing $1"
        $INSTALL $1
    }

    install_packages "git curl zsh ripgrep tmux zathura gdb python neovim $EXTRA_PACKAGES"

    # use zsh
    sudo chsh $USER -s $(which zsh) &&
        echo "Changed default shell to zsh"

    # oh-my-zsh
    (sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc) >> /dev/null &&
        echo "oh-my-zsh installed"

    mkdir -p ~/localwork/
    # neovim
    echo "Cloning neovim"
    git clone https://github.com/neovim/neovim ~/localwork/neovim

    # rust
    if command -v pacman &> /dev/null
    then
        rustup toolchain install nightly
        rustup toolchain install stable
        rustup default nightly
    else
        cargo install alacritty bottom
    fi
    cargo install fnm samply flamegraph cargo-valgrind wiki-tui

    . ~/.nvm/nvm.sh
    fnm install v20.5.1

elif [[ $platform =~ "MINGW" ]]; then
    # Windows
    echo "This should be run using git bash"
    cmd <<< "mklink /D %HOMEPATH%\\AppData\\Local\\nvim %HOMEPATH%\\.config\\nvim\\"
    echo "Created symlink for nvim settings"
fi

exit 0

