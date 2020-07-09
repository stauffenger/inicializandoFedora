#!/bin/bash

echo 'Installing basic repositories.'
#rpm fusion
dnf install -yq https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
#Flatpak/Flathub
sudo dnf install -yq flatpak;
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;
#Third Party Software Repositories
sudo dnf install fedora-workstation-repositories;
#Enabling Google Chrome repository
sudo dnf config-manager --set-enabled google-chrome;