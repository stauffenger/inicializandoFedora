#!/bin/bash

echo 'Instalando programas via dnf';
dnf install -yq telegram-desktop steam*;

echo 'Instalando programas via flatpak';
flatpak install -y flathub com.discordapp.Discord --noninteractive;