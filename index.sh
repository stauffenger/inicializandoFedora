dnf install wget -y;

#add repos

#postgress
dnf install https://download.postgresql.org/pub/repos/yum/reporpms/F-31-x86_64/pgdg-fedora-repo-latest.noarch.rpm;

#rpm fusion
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;


#sublime text
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg;
dnf config-manager --add-repo https://download.sublimetext.com/rpm/dev/x86_64/sublime-text.repo;

#vscode
rpm --import https://packages.microsoft.com/keys/microsoft.asc;
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';

#nvidia(negative 17)
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo;

dnf check-update;

#add flatpak repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;

#install programs

#nivida driver
dnf install -y nvidia-driver nvidia-driver-libs.i686 nvidia-settings akmod-nvidia cuda nvidia-driver-cuda;


dnf install -y telegram spotify vscode sublime-text codeblocks npm golang steam*;


flatpak install org.DolphinEmu.dolphin-emu;

flatpak install com.wps.Office;