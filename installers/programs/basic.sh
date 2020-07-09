#!/bin/bash

dnf install wget -yq;
echo 'Instalando programas via dnf';
dnf install -yq java-1.8.0-open* java-11-open* screenfetch stacer nano htop system-config-language numlockx vlc* google-chrome-stable;
echo 'Configurando Java:';
echo 1 | alternatives --config java;
java --version
echo 'Instalando programas via flatpak';
flatpak install -y flathub com.wps.Office --noninteractive;
flatpak install -y flathub org.DolphinEmu.dolphin-emu --noninteractive;
flatpak install -y flathub com.spotify.Client --noninteractive;