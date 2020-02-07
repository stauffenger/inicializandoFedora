#!/bin/bash

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
#dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo;

dnf check-update;

#add flatpak repo
sudo dnf install -yq flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;

#install programs

#nivida driver
#echo 'Instalando drivers Nvidia';
#dnf install -yq nvidia-driver nvidia-driver-libs.i686 nvidia-settings akmod-nvidia cuda nvidia-driver-cuda --allowerasing --best ;

echo 'Instalando programas via dnf';
dnf install -yq telegram-desktop code stacer nano fira-code-fonts xorg-x11-drv-amdgpu xorg-x11-drv-geode flat-remix-theme flat-remix-*-theme rabbitvcs* system-config-language sublime-text numlockx codeblocks krita pgadmin3 pgadmin4 vlc* gimp blender npm golang steam*;
dnf groupinstall -yq 'PostgreSQL Database Server 11 PGDG' --with-optional;

echo 'Inicializando a configuração Postgres 11';
/usr/pgsql-11/bin/postgresql-11-setup initdb;
systemctl enable postgresql-11;
systemctl start postgresql-11;
systemctl start httpd; 
systemctl enable httpd;
cp ./exempl /etc/httpd/conf.d/pgadmin4.conf;
systemctl restart httpd;
mkdir -p /var/lib/pgadmin4/ /var/log/pgadmin4/;
echo "LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'
SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'
SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'
STORAGE_DIR = '/var/lib/pgadmin4/storage'" > /usr/lib/python3.7/site-packages/pgadmin4-web/config_distro.py;
python3 /usr/lib/python3.7/site-packages/pgadmin4-web/setup.py;
chown -R apache:apache /var/lib/pgadmin4 /var/log/pgadmin4;
semanage fcontext -a -t httpd_sys_rw_content_t "/var/lib/pgadmin4(/.*)?";
semanage fcontext -a -t httpd_sys_rw_content_t "/var/log/pgadmin4(/.*)?";
restorecon -R /var/lib/pgadmin4/;
restorecon -R /var/log/pgadmin4/;
systemctl restart httpd;
firewall-cmd --permanent --add-service=http;
firewall-cmd --reload;

echo 'Instalando programas via npm';
npm i -g npm;
npm i -g yarn;

echo 'Instalando programas via flatpak';
flatpak install -y flathub com.spotify.Client --noninteractive;

flatpak install -y flathub org.DolphinEmu.dolphin-emu --noninteractive;

flatpak install -y flathub com.discordapp.Discord --noninteractive;

flatpak install -y flathub com.wps.Office --noninteractive;

flatpak install -y flathub com.google.AndroidStudio --noninteractive;

echo 'Iniciando download de Google Chrome';
#wget -c https://mega.nz/linux/MEGAsync/Fedora_31/x86_64/megasync-Fedora_31.x86_64.rpm ;

#wget -c https://mega.nz/linux/MEGAsync/Fedora_31/x86_64/nemo-megasync-Fedora_31.x86_64.rpm;

wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm;

echo 'Instalando Mega e Google Chrome... ';
#dnf install -yq megasync-Fedora_31.x86_64.rpm nemo-megasync-Fedora_31.x86_64.rpm google-chrome-stable_current_x86_64.rpm;
dnf install -yq google-chrome-stable_current_x86_64.rpm;

echo 'Fim do Script Inicializando Fedora'
