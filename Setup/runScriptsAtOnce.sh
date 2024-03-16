#!/usr/bin/sh

# run multiple install scripts


./sudoNoPass.sh
./zshrc-setup
./github-cli_install.sh
./n+vim-CopilotInstall
sudo cp fzsi /usr/bin
sudo cp clipToFile.sh /usr/bin
