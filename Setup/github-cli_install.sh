#!/usr/bin/sh

# install github commandline (gh)


sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh
sudo dnf update gh
gh auth login
gh extensions install github/gh-copilot --force
echo alias "??"="gh copilot suggest -t shell " 
