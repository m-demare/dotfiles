#/bin/bash

platform=$(uname)

if [[ $platform =~ "Linux" ]]; then

    if ! command -v apt-get &> /dev/null
    then
        INSTALL="sudo pacman --noconfirm -Syu"
        NVIM_DEPS="base-devel cmake unzip ninja tree-sitter curl"
        ALACRITTY_DEPS="cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python"
    else
        echo "Updating repos"
        sudo apt-get update >> /dev/null
        INSTALL="sudo apt-get -y install"
        NVIM_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"
        ALACRITTY_DEPS="cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3"
    fi

    install_packages(){
        $INSTALL $1 >> /dev/null
    }

    install_packages "git curl zsh ripgrep tmux $NVIM_DEPS $ALACRITTY_DEPS"

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

    # gdb-dashboard
    curl https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -o ~/.gdbinit

    # alacritty
    echo "Installing alacritty"
    ~/.cargo/bin/cargo install alacritty

    mkdir -p ~/localwork/
    # neovim
    echo "Building neovim"
    git clone https://github.com/neovim/neovim ~/localwork/neovim
    cd ~/localwork/neovim &&
    git checkout "release-0.6" &&
    sudo make distclean >> /dev/null &&
    make CMAKE_BUILD_TYPE=RelWithDebInfo &&
    sudo make install

    # for some reason I couldn't install node from this script, nvm was not found
    echo "Please run 'nvm install \$vim_node_version' manually"

elif [[ $platform =~ "MINGW" ]]; then
    # Windows
    echo "This should be run using git bash"
    cmd <<< "mklink /D %HOMEPATH%\\AppData\\Local\\nvim %HOMEPATH%\\.config\\nvim\\"
    echo "Created symlink for nvim settings"
fi

exit 0

