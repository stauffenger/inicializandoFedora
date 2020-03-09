#!/bin/bash

set -o errexit

#Funções
function error_message () {
    if [ $# -gt 0 ]; then
        local errorType="$1"
        case $errorType in
            invalid)
                echo "ERROR: \"${2}\" invalid argument. Use \"--help\" to see all options."
                ;;
            empty)
                echo "ERROR: \"${2}\" requires a non-empty option argument. Use \"--help\" to see all options."
                ;;
            *)
                error_message invalid 'error_message_FOR_DEBUG_PURPOSE'
                exit 1
                ;;
        esac
    else
        error_message empty 'error_message_FOR_DEBUG_PURPOSE'
        exit 1
    fi
}

function change_desktop_environment () {
    dnf swap @${1}-desktop-environment @${2}-desktop-environment
    #https://docs.fedoraproject.org/en-US/quick-docs/switching-desktop-environments/
    local displayManager=''
    select_display_manager ${1}
    local displayManager_1=$displayManager
    select_display_manager ${2}
    local displayManager_2=$displayManager
    dnf swap ${displayManager_1} ${displayManager_2}
}

function select_display_manager () {
    local desktopEnvironment="$1"
    case $desktopEnvironment in
        kde) 
            displayManager="kdm"
            ;;
        gnome) 
            displayManager="gdm"
            ;;
        *) 
            displayManager="LightDM"
            ;;
    esac
}

function install_repositories () {
    local repository="$1"
    case $repository in
        basic)
            #rpm fusion
            dnf install -yq https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

            #flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            ;;
        dev)
            #postgress
            dnf install -yq https://download.postgresql.org/pub/repos/yum/reporpms/F-31-x86_64/pgdg-fedora-repo-latest.noarch.rpm;

            #sublime text
            rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

            #vscode
            rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            ;;
        social)
            ;;
        all)
            install_repositories dev
            install_repositories social
            ;;
        nvidia)
            dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
            ;;
    esac
    dnf check-update;
}

function install_programs () {
    local programs="$1"
    case $programs in
        basic)
            dnf install wget -yq
            dnf install -yq flatpak stacer system-config-language numlockx krita vlc* gimp
            #Iniciando download de Google Chrome
            wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
            dnf install -yq google-chrome-stable_current_x86_64.rpm

            #Instalando programas via flatpak
            flatpak install -yq flathub com.wps.Office --noninteractive
            ;;
        dev)
            #Instalando programas via dnf
            dnf install -yq code nano rabbitvcs* sublime-text codeblocks pgadmin4 blender npm golang
            dnf groupinstall -yq 'PostgreSQL Database Server 10 PGDG' --with-optional

            echo 'Inicializando a configuração Postgres 10'
            /usr/pgsql-10/bin/postgresql-10-setup initdb
            systemctl enable postgresql-10
            systemctl start postgresql-10
            systemctl start httpd 
            systemctl enable httpd
            cp ./exempl /etc/httpd/conf.d/pgadmin4.conf
            systemctl restart httpd
            mkdir -p /var/lib/pgadmin4/ /var/log/pgadmin4/
            echo "LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'
            SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'
            SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'
            STORAGE_DIR = '/var/lib/pgadmin4/storage'" >> /usr/lib/python3.7/site-packages/pgadmin4-web/config_distro.py
            python3 /usr/lib/python3.7/site-packages/pgadmin4-web/setup.py
            chown -R apache:apache /var/lib/pgadmin4 /var/log/pgadmin4
            semanage fcontext -a -t httpd_sys_rw_content_t "/var/lib/pgadmin4(/.*)?"
            semanage fcontext -a -t httpd_sys_rw_content_t "/var/log/pgadmin4(/.*)?"
            restorecon -R /var/lib/pgadmin4/
            restorecon -R /var/log/pgadmin4/
            systemctl restart httpd
            firewall-cmd --permanent --add-service=http
            firewall-cmd --reload
            
            #Instalando programas via npm
            npm i -g npm
            npm i -g yarn

            #Instalando programas via flatpak
            flatpak install -yq flathub com.google.AndroidStudio --noninteractive
            ;;
        social)
            dnf install -yq telegram-desktop steam*
            #Iniciando download do Mega e do Mega Nemo extension
            wget -c https://mega.nz/linux/MEGAsync/Fedora_31/x86_64/megasync-Fedora_31.x86_64.rpm
            wget -c https://mega.nz/linux/MEGAsync/Fedora_31/x86_64/nemo-megasync-Fedora_31.x86_64.rpm
            dnf install -yq megasync-Fedora_31.x86_64.rpm nemo-megasync-Fedora_31.x86_64.rpm

            #Instalando programas via flatpak
            flatpak install -yq flathub com.spotify.Client --noninteractive
            flatpak install -yq flathub org.DolphinEmu.dolphin-emu --noninteractive
            flatpak install -yq flathub com.discordapp.Discord --noninteractive
            ;;
        all)
            install_programs dev
            install_programs social
            ;;
        nvidia)
            dnf install -yq nvidia-driver nvidia-driver-libs.i686 nvidia-settings akmod-nvidia cuda nvidia-driver-cuda --allowerasing --best
            ;;
        amd)
            dnf install -yq xorg-x11-drv-amdgpu xorg-x11-drv-geode
            ;;
    esac
}

# Main
if [ $# -gt 0 ]; then
    if [ "$1" == "--only" ]; then
        if [ $# -gt 1 ]; then
            shift
        else
            error_message empty ${1}
            exit 1
        fi
    else
        case "$1" in
            -h | -\? | --help)
                printf "
#################################### help #########################################
#                                                                                 #
#       -d | --desktop-environment  <kde | gnome | cinnamon | mate | xfce>        #
#       -g | --gpu <amd | nvidia>                                                 #
#       -h | --help | \\\?                                                          #
#          | --only                                                               #
#       -o | --with-optional <dev | social>                                       #
#       -t | --theme <abreu | pascoal>                                            #
#                                                                                 #
###################################################################################\n"
                exit 0
                ;;
        esac
    fi
else
    #install_repositories basic
    #install_programs basic
    echo 'something'
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -t | --theme)
            if [ "$2" ]; then
                local theme="$2"
                case $theme in
                    abreu) 
                        echo 'Abreu'
                        ;;
                    pascoal) 
                        echo 'Pascoal'
                        ;;
                    *)
                        error_message invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                error_message empty ${1}
                exit 1
            fi
            ;;
        -o | --with-optional)
            if [ "$2" ]; then
                local optionGroup="$2"
                case $optionGroup in
                    dev | social)
                        install_repositories ${optionGroup}
                        install_programs ${optionGroup}
                        ;;
                    *)
                        error_message invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                install_repositories all
                install_programs all
            fi
            ;;
        -g | --gpu)
            if [ "$2" ]; then
                local gpu="$2"
                case $gpu in
                    nvidea | amd) 
                        install_repositories ${gpu}
                        install_programs ${gpu}
                        ;;
                    *)
                        error_message invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                error_message empty ${1}
                exit 1
            fi
            ;;
        -d | --desktop-environment)
            if [ "$2" ] && [ "$3" ]; then
                local desktopEnvironment_1="$2"
                local desktopEnvironment_2="$3"
                case $desktopEnvironment_1 in
                    kde | gnome | cinnamon | mate | xfce)
                        case $desktopEnvironment_2 in
                            kde | gnome | cinnamon | mate | xfce)
                                change_desktop_environment ${desktopEnvironment_1} ${desktopEnvironment_2}
                                shift
                                shift
                                ;;
                            *)
                            error_message invalid ${desktopEnvironment_2}
                                exit 1
                                ;;
                        esac
                        ;;
                    *)
                        error_message invalid ${desktopEnvironment_1}
                        exit 1
                        ;;
                esac
            else
                error_message empty ${1}
                exit 1
            fi
            ;;
        *)
            error_message invalid ${1}
            exit 1
            ;;
    esac
    shift
done

exit 0