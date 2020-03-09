#!/bin/bash

set -o errexit

#Funções
function error_message () {
    if [ $# -gt 0 ]; then
        local errorType="$1"
        case errorType in
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
        cinnamon) 
            displayManager="mdm"
            ;;
        *) 
            displayManager="LightDM"
            ;;
    esac
}

#Tratando argumentos recebidos
if [ $# ]; then
    if [ "$1" == "--only" ]; then
        if [ $# -gt 1 ]; then
            shift
        else
            error_message empty ${1}
            exit 1
        fi
    else
        echo 'do something'
    fi
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -h | -\? | --help)
            echo 'help'
            exit 0
            ;;
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
                    dev) 
                        echo 'dev'
                        ;;
                    social) 
                        echo 'social'
                        ;;
                    *)
                        error_message invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                echo 'All optionals things'
            fi
            ;;
        -g | --gpu)
            if [ "$2" ]; then
                local gpu="$2"
                case $gpu in
                    nvidea) 
                        echo 'nvidea'
                        ;;
                    amd) 
                        echo 'amd'
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
                case desktopEnvironment_1 in
                    kde | gnome | cinnamon | mate | xfce)
                        case desktopEnvironment_2 in
                            kde | gnome | cinnamon | mate | xfce)
                                change_desktop_environment desktopEnvironment_1 desktopEnvironment_2
                                shift
                                shift
                                ;;
                            *)
                            error_message invalid desktopEnvironment_2
                                exit 1
                                ;;
                        esac
                        ;;
                    *)
                        error_message invalid desktopEnvironment_1
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