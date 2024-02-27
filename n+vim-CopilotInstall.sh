#!/usr/bin/sh

## Get source
## Build
### Configure
### Make
### Install


# Install Node.js
## Check for install

## Option 1 - Distro's package manager
### Check for appropriate node.js version in package manager
### Set env variables for node.js path
### Install using package manager

## Option 2 - NVM (node version manager)
### Set env variables
### Install nvm
### Install node

## Option 3 - Source
### Get source 
### Build
#### Configure
#### Make
#### Install


 # Install for vim
## get source and add to vim's dir
  #*TODO::add support for custom locations*#
git clone https://github.com/github/copilot.vim.git \
~/.vim/pack/github/start/copilot.vim
 ## open vim and run Copilot auth
vim -c Copilot auth
#::prompt user for completion before moving on:#
read -p "Press Enter after authorizing to continue..." userInput

# Install for neovim
git clone https://github.com/github/copilot.vim.git \
~/.config/nvim/pack/github/start/copilot.vim
## open vim and run Copilot auth
#nvim -V -c Copilot auth
nvim -c Copilot auth # removed verbosity- hard to copy auth code with it on

read -p "Press Enter after authorizing to continue..." userInput

