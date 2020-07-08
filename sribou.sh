#!/bin/bash

set -o errexit

# --------- Variables ----------
readonly PATH="$(pwd)"
readonly INSTALLERS_PATH="$PATH/installers"
readonly AMD_INSTALLERS_PATH="$INSTALLERS_PATH/drivers/amd.sh"
readonly NVIDIA_INSTALLERS_PATH="$INSTALLERS_PATH/drivers/nvidia.sh"
readonly BASIC_INSTALLERS_PATH="$INSTALLERS_PATH/programs/basic.sh"
readonly DEV_INSTALLERS_PATH="$INSTALLERS_PATH/programs/dev.sh"
readonly SOCIAL_INSTALLERS_PATH="$INSTALLERS_PATH/programs/social.sh"
readonly REPOSITORIES_PATH="$PATH/repositories"
readonly BASIC_REPOSITORIES_PATH="$REPOSITORIES_PATH/basic.sh"
readonly DEV_REPOSITORIES_PATH="$REPOSITORIES_PATH/dev.sh"
readonly SOCIAL_REPOSITORIES_PATH="$REPOSITORIES_PATH/social.sh"
readonly NVIDIA_REPOSITORIES_PATH="$REPOSITORIES_PATH/nvidia.sh"

# --------- Functions ----------
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
    systemctl enable ${displayManager_2}
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
            "$BASIC_REPOSITORIES_PATH"
            ;;
        dev)
            "$DEV_REPOSITORIES_PATH"
            ;;
        social)
            "$SOCIAL_REPOSITORIES_PATH"
            ;;
        all)
            install_repositories basic
            install_repositories dev
            install_repositories social
            ;;
        nvidia)
            "$NVIDIA_REPOSITORIES_PATH"
            ;;
    esac
    dnf check-update;
}

function install_programs () {
    local programs="$1"
    case $programs in
        basic)
            "$BASIC_INSTALLERS_PATH"
            ;;
        dev)
            "$DEV_INSTALLERS_PATH"
            ;;
        social)
            "$SOCIAL_INSTALLERS_PATH"
            ;;
        all)
            install_programs basic
            install_programs dev
            install_programs social
            ;;
    esac
}

function install_drivers () {
    local drivers="$1"
    case $drivers in
        nvidia)
            "$NVIDIA_INSTALLERS_PATH"
            ;;
        amd)
            "$AMD_INSTALLERS_PATH"
            ;;
    esac
}

# ---------- Main ----------
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
    install_repositories basic
    install_programs basic
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
                    nvidia | amd) 
                        install_repositories ${gpu}
                        install_drivers ${gpu}
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