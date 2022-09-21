#!/bin/bash

# Set execute permissions for brew.sh and npm.sh
chmod +x brew.sh
chmod +x npm.sh
chmod +x languages.sh

# Run brew.sh and npm.sh
sh brew.sh
sh npm.sh
sh languages.sh

# Install vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Move files to their correct place
cp .tmux.conf ~/.tmux.conf

if test -f ~/.config/nvim/init.vim; then
cp init.vim ~/.config/nvim/init.vim
else
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
fi

# Install neovim plugins without opening it so it doesn't error
nvim --headless +PlugInstall +qa
