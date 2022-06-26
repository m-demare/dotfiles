#/bin/bash

platform=$(uname)

if [[ $platform =~ "Linux" ]]; then

    if command -v pacman &> /dev/null
    then
        INSTALL="sudo pacman --noconfirm -Syu"
        NVIM_DEPS="nvim"
        EXTRA_PACKAGES="gdb-dashboard alacritty"
    else
        echo "Updating repos"
        sudo apt-get update >> /dev/null
        INSTALL="sudo apt-get -y install"
        NVIM_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"
        EXTRA_PACKAGES=""
    fi

    install_packages(){
        echo "Installing $1"
        $INSTALL $1
    }

    install_packages "git curl zsh ripgrep tmux zathura gdb python $NVIM_DEPS"

    # use zsh
    sudo chsh $USER -s $(which zsh) &&
        echo "Changed default shell to zsh"

    # Rust
    (sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" "" --no-modify-path -y) >> /dev/null &&
        echo "Rust installed"

    # nvm
    (curl -fsSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash) >> /dev/null &&
        echo "nvm installed"

    # oh-my-zsh
    (sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc) >> /dev/null &&
        echo "oh-my-zsh installed"

    echo "Installing bottom"
    ~/.cargo/bin/cargo install bottom

    mkdir -p ~/localwork/
    # neovim
    echo "Building neovim"
    git clone https://github.com/neovim/neovim ~/localwork/neovim
    if command -v apt-get &> /dev/null
    then
        cd ~/localwork/neovim &&
        sudo make distclean >> /dev/null &&
        make CMAKE_BUILD_TYPE=RelWithDebInfo &&
        sudo make install
    fi

    # for some reason I couldn't install node from this script, nvm was not found
    echo "Please run 'nvm install \$vim_node_version' manually"

elif [[ $platform =~ "MINGW" ]]; then
    # Windows
    echo "This should be run using git bash"
    cmd <<< "mklink /D %HOMEPATH%\\AppData\\Local\\nvim %HOMEPATH%\\.config\\nvim\\"
    echo "Created symlink for nvim settings"
fi

exit 0

