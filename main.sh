#!/bin/bash

set -o errexit

#Funções
function mensagem_de_erro () {
    if [ $# -gt 0 ]; then
        case "$1" in
            invalid)
                echo "ERROR: \"${2}\" invalid argument. Use \"--help\" to see all options."
                ;;
            empty)
                echo "ERROR: \"${2}\" requires a non-empty option argument. Use \"--help\" to see all options."
                ;;
            *)
                mensagem_de_erro invalid 'mensagem_de_erro_FOR_DEBUG_PURPOSE'
                exit 1
                ;;
        esac
    else
        mensagem_de_erro empty 'mensagem_de_erro_FOR_DEBUG_PURPOSE'
        exit 1
    fi
}

function change_desktop_environment () {
    dnf swap @${1}-desktop-environment @${2}-desktop-environment
    #https://docs.fedoraproject.org/en-US/quick-docs/switching-desktop-environments/
    local display_manager=''
    select_display_manager ${1}
    display_manager_1=$display_manager
    select_display_manager ${2}
    display_manager_2=$display_manager
    dnf swap ${display_manager_1} ${display_manager_2}
}

function select_display_manager () {
    desktopEnvironment=$1
    case "$desktopEnvironment" in
        kde) 
            display_manager="kdm"
            ;;
        gnome) 
            display_manager="gdm"
            ;;
        cinnamon) 
            display_manager="mdm"
            ;;
        *) 
            display_manager="LightDM"
            ;;
    esac
}

#Tratando argumentos recebidos
if [ $# ]; then
    if [ "$1" == "--only" ]; then
        if [ $# -gt 1 ]; then
            shift
        else
            mensagem_de_erro empty ${1}
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
                theme="$2"
                case "$theme" in
                    abreu) 
                        echo 'Abreu'
                        ;;
                    pascoal) 
                        echo 'Pascoal'
                        ;;
                    *)
                        mensagem_de_erro invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                mensagem_de_erro empty ${1}
                exit 1
            fi
            ;;
        -o | --with-optional)
            if [ "$2" ]; then
                optionGroup="$2"
                case "$optionGroup" in
                    dev) 
                        echo 'dev'
                        ;;
                    social) 
                        echo 'social'
                        ;;
                    *)
                        mensagem_de_erro invalid ${1}
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
                gpu="$2"
                case "$gpu" in
                    nvidea) 
                        echo 'nvidea'
                        ;;
                    amd) 
                        echo 'amd'
                        ;;
                    *)
                        mensagem_de_erro invalid ${1}
                        exit 1
                        ;;
                esac
                shift
            else
                mensagem_de_erro empty ${1}
                exit 1
            fi
            ;;
        -d | --desktop-environment)
            if [ "$2" ] && [ "$3" ]; then
                case "$2" in
                    kde | gnome | cinnamon | mate | xfce)
                        case "$3" in
                            kde | gnome | cinnamon | mate | xfce)
                                change_desktop_environment ${2} ${3}
                                shift
                                shift
                                ;;
                            *)
                            mensagem_de_erro invalid ${3}
                                exit 1
                                ;;
                        esac
                        ;;
                    *)
                        mensagem_de_erro invalid ${2}
                        exit 1
                        ;;
                esac
            else
                mensagem_de_erro empty ${1}
                exit 1
            fi
            ;;
        *)
            mensagem_de_erro invalid ${1}
            exit 1
            ;;
    esac
    shift
done

exit 0