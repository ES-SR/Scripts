#!/usr/bin/sh

#MEGA backup install and login
# MegaSetup email passwd


# Fedora 39
wget https://mega.nz/linux/repo/Fedora_39/x86_64/megacmd-Fedora_39.x86_64.rpm && \
sudo dnf install "$PWD/megacmd-Fedora_39.x86_64.rpm"


mega-login $1 $2


