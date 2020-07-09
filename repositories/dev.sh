#!/bin/bash

echo 'Installing developer repositories.'
#postgress
dnf install -yq https://download.postgresql.org/pub/repos/yum/reporpms/F-31-x86_64/pgdg-fedora-repo-latest.noarch.rpm;
#vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc;
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';