#!/bin/bash

set -o errexit

#Tratando argumentos recebidos
if [ $# ]; then
    if [ "$1" == "--only" ]; then
        shift
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
                        echo 'ERROR: "--theme" invalid argument.'
                        exit 1
                        ;;
                esac
                shift
            else
                echo 'ERROR: "--theme" requires a non-empty option argument.'
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
                        echo 'ERROR: "--with-optional" invalid argument.'
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
                        echo 'ERROR: "--gpu" invalid argument.'
                        exit 1
                        ;;
                esac
                shift
            else
                echo 'ERROR: "--gpu" requires a non-empty option argument.'
                exit 1
            fi
            ;;
        -d | --desktop-environment)
            if [ "$2" ]; then
                desktopEnvironment="$2"
                case "$desktopEnvironment" in
                    kde) 
                        echo '@kde-desktop-environment / kdm'
                        ;;
                    gnome) 
                        echo '@gnome-desktop-environment / gdm'
                        ;;
                    cinnamon) 
                        echo '@cinnamon-desktop-environment / LightDM'
                        ;;
                    mate) 
                        echo '@mate-desktop-environment / LightDM'
                        ;;
                    xfce) 
                        echo '@xfce-desktop-environment / LightDM'
                        ;;
                    *)
                        echo 'ERROR: "--desktop-environment" invalid argument.'
                        exit 1
                        ;;
                esac
                shift
            else
                echo 'ERROR: "--desktop-environment" requires a non-empty option argument.'
                exit 1
            fi
            ;;
        *)
            echo "ERROR: \"${1}\" invalid argument."
            exit 1
            ;;
    esac
    shift
done

exit 0