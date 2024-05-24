#! /usr/bin/env bash

# Tested on Ubuntu 24.04 LTS without existing nvim configuration

set -eu pipefall

echo 'Updating and upgrading packages'
sudo apt update && sudo apt upgrade -y

################################################## 

echo '\nInstalling Vim configuration'
curl -o- https://raw.githubusercontent.com/afairless/dotfiles/main/.vimrc > ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# upon initially starting Vim, run :PlugInstall
# nvim -c 'PlugInstall'

################################################## 

echo '\nInstalling Tmux configuration'
curl -o- https://raw.githubusercontent.com/afairless/dotfiles/main/.tmux.conf > ~/.tmux.conf

################################################## 

echo '\nInstalling Neovim using LunarVim installer'
curl -o- https://raw.githubusercontent.com/LunarVim/LunarVim/master/utils/installer/install-neovim-from-release | bash

echo 'alias nvim=~/.local/bin/nvim' > ~/.bash_aliases

echo 'Installing Neovim package manager Packer'
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim


if [ -d ~/.config/nvim ]; then
  echo 'Existing NeoVim configuration detected.  Overwrite it with new configuration? (Y/N)'
  read response
  if [ '$response' == 'Y' ] || [ '$response' == 'y' ]; then
    echo 'Existing NeoVim configuration will be moved to backup *.bak directories'
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak
  fi
fi

mkdir -p ~/.config/nvim/lua
curl -o- https://raw.githubusercontent.com/afairless/dotfiles/main/.config/nvim/init.lua > ~/.config/nvim/init.lua
curl -o- https://raw.githubusercontent.com/afairless/dotfiles/main/.config/nvim/lua/plugins.lua > ~/.config/nvim/lua/plugins.lua
# upon initially starting Neovim, run :PackerSync
# nvim -c 'PackerSync'

################################################## 

echo 'Installing LunarVim dependencies'

echo 'Installing npm, package manager for Node.js'
echo y | sudo apt-get install npm
echo y | sudo npm i -g neovim

echo 'Installing pip, package manager for Python'
echo y | sudo apt install python3-pip
echo 'Installing pynvim, a Python dependency for LunarVim'
echo y | sudo apt install python3-pynvim

echo 'Installing venv for Python virtual environments (not a LunarVim dependency)'
echo y | sudo apt install python3-venv
# python -m venv ~/.venv
# echo 'source ~/.venv/bin/activate' >> ~/.bashrc

echo 'Installing LunarVim'
# from:  https://www.lunarvim.org/docs/installation
echo y | LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
curl -o- https://raw.githubusercontent.com/afairless/dotfiles/main/.config/lvim/config.lua > ~/.config/lvim/config.lua

echo 'alias lvim=~/.local/bin/lvim' >> ~/.bash_aliases

echo '\nRun the following in the terminal to update aliases:  source ~/.bashrc'


