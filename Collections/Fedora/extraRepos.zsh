#!/bin/zsh


# set up extra repos for use on Fedora

# Fusion Repo
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


sudo dnf config-manager --enable fedora-cisco-openh264



# enable installation from gnome software/kde discover. Appstream metadata- only for gui packages
sudo dnf groupupdate core


# Switch to full ffmpeg
sudo dnf swap ffmpeg-free ffmpeg --allowerasing



# Install additional codec
# multimedia packages needed by gstreamer enabled applications
sudo dnf groupupdate multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# sound-and-video complement packages needed by some applications
sudo dnf groupupdate sound-and-video


# Hardware codecs with AMD (mesa)
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld


# Hardware codecs with NVIDIA
sudo dnf install nvidia-vaapi-driver

# Various firmwares
sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"
