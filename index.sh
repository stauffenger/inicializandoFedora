#!/bin/bash

bashrc='#!/usr/bin/env bash

# If not running interactively, dont do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/home/$USER/.bash-it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME="powerline"

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE="bash-it"

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING="git@git.domain.com"

# Dont check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT="irssi"

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh
';

dnf install wget -y;

#add repos
echo 'Adicionando repositorios...';
#postgress
dnf install -yq https://download.postgresql.org/pub/repos/yum/reporpms/F-31-x86_64/pgdg-fedora-repo-latest.noarch.rpm;

#rpm fusion
dnf install -yq https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;


#sublime text
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

#vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc;
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';

#nvidia(negative 17)
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo;

dnf upgrade -yq;

#add flatpak repo
sudo dnf install -yq flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;

#install programs

#nivida driver
echo 'Instalando drivers Nvidia';
dnf install -yq nvidia-driver nvidia-driver-libs.i686 nvidia-settings akmod-nvidia cuda nvidia-driver-cuda --allowerasing --best ;

echo 'Instalando drivers PostgreSQL Server 12';
dnf groupinstall -yq 'PostgreSQL Database Server 10 PGDG' --with-optional;

echo 'Instalando programas via dnf';
dnf install -yq telegram-desktop code postgresql-server postgresql-contrib java-1.8.0-openjdk java-11-openjdk stacer nano htop fira-code-fonts flat-remix-theme flat-remix-*-theme system-config-language sublime-text numlockx krita pgadmin3 vlc* gimp blender npm golang steam*;

echo 'Startando o postgres';
systemctl enable postgresql;
systemctl start postgresql;
postgresql-setup --initdb --unit postgresql;

echo 'Instalando programas via npm';
npm i -g npm;
npm i -g yarn;

echo 'Instalando programas via flatpak';
flatpak install -y flathub com.spotify.Client --noninteractive;

flatpak install -y flathub org.DolphinEmu.dolphin-emu --noninteractive;

flatpak install -y flathub com.discordapp.Discord --noninteractive;

flatpak install -y flathub com.wps.Office --noninteractive;

flatpak install -y flathub com.google.AndroidStudio --noninteractive;

flatpak install -y flathub io.dbeaver.DBeaverCommunity --noninteractive;
flatpak install -y flathub io.dbeaver.DBeaverCommunity.Client.pgsql --noninteractive;

echo 'Iniciando download de Google Chrome';
wget -c https://mega.nz/linux/MEGAsync/Fedora_$(rpm -E %fedora)/x86_64/megasync-Fedora_$(rpm -E %fedora).x86_64.rpm ;

wget -c https://mega.nz/linux/MEGAsync/Fedora_$(rpm -E %fedora)/x86_64/nautilus-megasync-Fedora_$(rpm -E %fedora).x86_64.rpm;

wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm;

#wget -c https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm;

echo 'Instalando Mega e Google Chrome... ';
dnf install -yq megasync-Fedora_$(rpm -E %fedora).x86_64.rpm nemo-megasync-Fedora_$(rpm -E %fedora).x86_64.rpm google-chrome-stable_current_x86_64.rpm; # dbeaver-ce-latest-stable.x86_64.rpm;


echo 'Instalando Tema Terminal';
git clone https://github.com/Bash-it/bash-it.git /home/$USER/.bash-it/;
chmod +x /home/$USER/.bash-it/install.sh;
echo 'y' | sh /home/$USER/.bash-it/install.sh;
echo $bashrc >> /home/$USER/.bashrc ;
cp /home/$USER/.bashrc /root/.bashrc ;

echo 'Configurando VS Code';
su -l $USER
code --install-extension teabyii.ayu ;
code --install-extension dbaeumer.vscode-eslint ;
code --install-extension esbenp.prettier-vscode ;
code --install-extension ms-python.python;
code --install-extension vscode-icons-team.vscode-icons;

echo '{ 
	"workbench.iconTheme": "vscode-icons",
	 "workbench.colorTheme": "Ayu Mirage",
	  "editor.fontFamily": "Fira Code Retina",
	  "editor.formatOnType": true,
	  "editor.fontLigatures": true,
	  "explorer.confirmDelete": false,
	  "editor.formatOnSave": true,
	  "prettier.eslintIntegration": true,
	  "editor.defaultFormatter": "esbenp.prettier-vscode",
	  "[javascript]": {"editor.defaultFormatter": "esbenp.prettier-vscode"},
	  }' > /home/$USER/.config/Code/User/settings.json;

echo 'Fim do Script Inicializando Fedora';
echo 'Lembre de configurar as permissões do postgres -> README: Documentação de configuração do Fedora';
echo 'Bye e bom uso :D';
