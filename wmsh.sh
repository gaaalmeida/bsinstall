#!/bin/bash

## Check variables
#WM
wmish_backtitle="Window Manager Installer in Shell"
wm_bspwm_checked=OFF

#BAR
bar_lemonbar_checked=OFF
bar_polybar_checked=OFF

#LEMONBAR_CONFIG
lemon_cfg_default_checked=ON
lemon_cfg_folder_checked=OFF
lemon_cfg_example_checked=OFF
lemon_cfg_export_checked=OFF

#POLYBAR_CONFIG
polybar_cfg_alsa_checked=OFF
polybar_cfg_pulseaudio_checked=OFF
polybar_cfg_network_checked=OFF
polybar_cfg_mpd_checked=OFF
polybar_cfg_git_checked=OFF
polybar_cfg_default_checked=ON
polybar_cfg_nerdfont_checked=OFF

#Display Manager
dm_lightdm_checked=OFF
dm_xinit_checked=OFF

#LightDM Configuration
lightdm_cfg_bspwmdesktop_checked=ON

#Xinit Configuration
xinit_cfg_sxhkd_checked=ON
xinit_cfg_bspwm_checked=ON

#Additional Pkackages
additional_pkgs_curl_checked=OFF
additional_pkgs_wget_checked=OFF

#
bar_choosed_cfg=""

## MENU
menu_window=welcome


## INSTALLERS
#bspwm
bspwm_dependencies="git gcc make xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev"
bspwm_link="https://github.com/baskerville/bspwm.git"
#sxhkd
sxhkd_link="https://github.com/baskerville/sxhkd.git"

#LemonBar
lemonbar_link="https://github.com/LemonBoy/bar.git"
lemonbar_dependencies="xdo sutils xtitle"
## Menu loop
while : ; do

    case "$menu_window" in
        welcome)
            menu_window=menu
            dialog --backtitle "${wmish_backtitle}" \
                --msgbox 'Caution! this script is going to install packages and configurations files in your PC. So... take care!' 0 0
            ;;
        menu)
            echo "$wm"
            previous=welcome
            menu=$( dialog --stdout \
                    --backtitle "${wmish_backtitle}" \
                    --menu 'Menu' 0 0 0 \
                    1 'Select Window Manager'        \
                    2 'Select Bar' \
                    3 'Select Display Manager' \
                    4 'Additional Packages' \
                    5 'Install' \
                    6 'EXIT')
            if [[ $menu == *"1"* ]]; then
                menu_window=wm_select
            elif [[ $menu == *"2"* ]]; then
                menu_window=bar_select
            elif [[ $menu == *"3"* ]]; then
                menu_window=dm_select
            elif [[ $menu == *"4"* ]]; then
                menu_window=additional_pkgs
            elif [[ $menu == *"5"* ]]; then
                menu_window=list_options
            elif [[ $menu == *"6"* ]]; then
                menu_window=quit_alert
            fi
            ;;
        wm_select)
            menu_window=menu
            if [[ $wm == *"bspwm"* ]]; then
                wm_bspwm_checked=ON
            fi
            wm=$( dialog --stdout \
                    --backtitle "${wmish_backtitle}" \
                    --radiolist 'Choose the Window Manager' 0 0 0 \
                    'bspwm' 'Binary Space Partitioning Window Manager' ${wm_bspwm_checked})
            previous=menu
            ;;
        bar_select)
            menu_window=menu
            bar=$( dialog --stdout \
                    --backtitle "${wmish_backtitle}" \
                    --radiolist 'Choose the Bar' 0 0 0 \
                    'LemonBar' 'Featherweight lemon-scented bar' ${bar_lemonbar_checked} \
                    'Polybar' 'A fast and easy-to-use status bar' ${bar_polybar_checked})
            if [[ $bar == *"LemonBar"* ]]; then
                bar_lemonbar_checked=ON
                bar_polybar_checked=OFF
                menu_window=lemonbar_config
                bar_choosed_cfg=$lemon_cfg
            elif [[ $bar == *"Polybar"* ]]; then
                bar_polybar_checked=ON
                bar_lemonbar_checked=OFF
                menu_window=polybar_config
                bar_choosed_cfg=$polybar_cfg
            fi
            ;;
        lemonbar_config)
            lemon_cfg=$( dialog --stdout \
                            --backtitle "${wmish_backtitle}" \
                            --checklist 'LemonBar Configuration' 0 0 0 \
                            'default' 'All the alternatives below' ${lemon_cfg_default_checked} \
                            'folder' 'Create bar folder inside ~/.config/bspwm' ${lemon_cfg_folder_checked} \
                            'example' 'Copy default example from bspwm' ${lemon_cfg_example_checked} \
                            'export' 'Export FIFO and link with bspwmrc' ${lemon_cfg_export_checked})
            menu_window=menu
            echo "$lemon_cfg"
            if [[ $lemon_cfg == *"folder"* ]]; then
                lemon_cfg_folder_checked=ON;
            else
                lemon_cfg_folder_checked=OFF;
            fi

            if [[ $lemon_cfg == *"example"* ]]; then
                lemon_cfg_example_checked=ON;
            else
                lemon_cfg_example_checked=OFF;
            fi

            if [[ $lemon_cfg == *"export"* ]]; then
                lemon_cfg_export_checked=ON;
            else
                lemon_cfg_export_checked=OFF;
            fi

            if [[ $lemon_cfg == *"default"* || -z "$lemon_cfg" ]]; then
                lemon_cfg_folder_checked=OFF
                lemon_cfg_example_checked=OFF
                lemon_cfg_export_checked=OFF
                lemon_cfg_default_checked=ON
            else
                lemon_cfg_default_checked=OFF;
            fi
            previous=menu
            ;;
        polybar_config)
            if [[ $polybar_cfg == *"internal/alsa"* ]]; then
                polybar_cfg_alsa_checked=ON;
            else
                polybar_cfg_alsa_checked=OFF;
            fi

            if [[ $polybar_cfg == *"internal/pulseaudio"* ]]; then
                polybar_cfg_pulseaudio_checked=ON;
            else
                polybar_cfg_pulseaudio_checked=OFF;
            fi

            if [[ $polybar_cfg == *"internal/network"* ]]; then
                polybar_cfg_network_checked=ON;
            else
                polybar_cfg_network_checked=OFF;
            fi

            if [[ $polybar_cfg == *"internal/mpd"* ]]; then
                polybar_cfg_mpd_checked=ON;
            else
                polybar_cfg_mpd_checked=OFF;
            fi

            if [[ $polybar_cfg == *"internal/github"* ]]; then
                polybar_cfg_git_checked=ON;
            else
                polybar_cfg_git_checked=OFF;
            fi

            if [[ $polybar_cfg == *"font"* ]]; then
                polybar_cfg_nerdfont_checked=ON;
            else
                polybar_cfg_nerdfont_checked=OFF;
            fi

            if [[ $polybar_cfg == *"default"* || -z "$polybar_cfg" ]]; then
                polybar_cfg_default_checked=ON;
                polybar_cfg_pulseaudio_checked=OFF;
                polybar_cfg_mpd_checked=OFF;
                polybar_cfg_git_checked=OFF;
                polybar_cfg_nerdfont_checked=OFF;
            else
                polybar_cfg_default_checked=OFF;
            fi

            polybar_cfg=$( dialog --stdout \
                            --backtitle "${wmish_backtitle}" \
                            --checklist 'Polybar Support CFG' 0 0 0 \
                            'default' 'pulseaudio, mpd, github, nerd-font' ${polybar_cfg_default_checked} \
                            'internal/alsa' 'alsalib' ${polybar_cfg_alsa_checked} \
                            'internal/pulseaudio' 'libpulse' ${polybar_cfg_pulseaudio_checked} \
                            'internal/network' 'libn1/libiw' ${polybar_cfg_network_checked} \
                            'internal/mpd' 'libmpdclient' ${polybar_cfg_mpd_checked} \
                            'internal/github' 'libcurl' ${polybar_cfg_git_checked} \
                            'font' 'nerd-font' ${polybar_cfg_nerdfont_checked})
            menu_window=menu
            ;;
        dm_select)
            dm=$( dialog --stdout \
                    --backtitle "${wmish_backtitle}" \
                    --radiolist 'Select the Display Manager' 0 0 0 \
                    'lightdm' 'A X display manager' ${dm_lightdm_checked} \
                    'xinit' 'Used to start DE and apps' ${dm_xinit_checked})
            previous=menu
            menu_window=menu
            if [[ $dm == *"lightdm"* ]]; then
                dm_lightdm_checked=ON
                dm_xinit_checked=OFF
                menu_window=lightdm_config
            elif [[ $dm == *"xinit"* ]]; then
                dm_xinit_checked=ON
                dm_lightdm_checked=OFF
                menu_window=xinit_config
            fi
            ;;
        lightdm_config)
            if [[ $lightdm_cfg == *"bspwm.desktop"* ]]; then
                lightdm_cfg_bspwmdesktop_checked=ON;
            else
                lightdm_cfg_bspwmdesktop_checked=OFF;
            fi

            lightdm_cfg=$( dialog --stdout \
                            --separate-output \
                            --backtitle "${wmish_backtitle}" \
                            --checklist 'Set the config for LightDM' 0 0 0 \
                            'bspwm.desktop' 'Copy bspwm.desktop to lightdm(xsessions)' ${lightdm_cfg_bspwmdesktop_checked})
            menu_window=menu
            ;;
        xinit_config)
            if [[ $xinit_cfg == *"bspwm"* ]]; then
                xinit_cfg_bspwm_checked=ON;
            else
                xinit_cfg_bspwm_checked=OFF;
            fi

            if [[ $xinit_cfg == *"sxhkd"* ]]; then
                xinit_cfg_sxhkd_checked=ON;
            else
                xinit_cfg_sxhkd_checked=OFF;
            fi

            xinit_cfg=$( dialog --stdout \
                            --separate-output \
                            --backtitle "${wmish_backtitle}" \
                            --checklist 'Set the config for Xinit(xinitrc)' 0 0 0 \
                            'bspwm' 'Load BSPWM' ${xinit_cfg_bspwm_checked} \
                            'sxhkd' 'Load SXHKD' ${xinit_cfg_sxhkd_checked})
            menu_window=menu
            previous=dm_select
            ;;
        additional_pkgs)
            if [[ $add_pkgs == *"curl"* ]]; then
                additional_pkgs_curl_checked=ON;
            else
                additional_pkgs_curl_checked=OFF;
            fi

            if [[ $add_pkgs == *"wget"* ]]; then
                additional_pkgs_wget_checked=ON;
            else
                additional_pkgs_wget_checked=OFF;
            fi
            add_pkgs=$( dialog --stdout \
                        --backtitle "${wmish_backtitle}" \
                        --checklist 'Add more packages' 0 0 0 \
                        'curl' 'Library for transferring data with URLs' ${additional_pkgs_curl_checked} \
                        'wget' 'Package for retrieving files using HTTP, HTTPS, FTP and FTPS' ${additional_pkgs_wget_checked})       
            previous=menu
            menu_window=menu
            ;;
        list_options)
            if [[ $bar == *"LemonBar"* ]]; then
                bar_choosed_cfg=$lemon_cfg
            else
                bar_choosed_cfg=$polybar_cfg
            fi
            if [[ $dm == *"lightdm"* ]]; then
                dm_choosed_cfg=$lightdm_cfg
            else
                dm_choosed_cfg=$xinit_cfg
            fi
            whiptail \
                --backtitle "${wmish_backtitle}" \
                --title 'Packages to be installed' \
                --yesno --yes-button 'Install' --no-button 'Modify Settings' "
Window Manager: $wm
Bar: $bar
Bar Config: $bar_choosed_cfg
Display Manager: $dm
DM Settings: $dm_choosed_cfg
Additional Packages: $add_pkgs
                " 0 70
            response=$?
            previous=menu
            if [ "$response" -eq 0 ]; then
                whiptail \
                --title 'Install Alert' \
                --yesno --yes-button "Install" --no-button "Back" 'Do you really want to install?' \
                0 0
                response=$?
                previous=menu
                if [ "$response" -eq 0 ]; then
                    break 4
                fi
            else
                menu_window=menu
            fi
            ;;
        quit_alert)
            whiptail \
                --title 'Alert' \
                --yesno --yes-button "Leave" --no-button "Back" 'Do you really want to leave?\nYour settings will be lost!' \
                0 0
            response=$?
            previous=menu
            if [ "$response" -eq 0 ]; then
                exit
            else
                menu_window=menu
            fi
            ;;
    esac

previous=$?
[ $previous -eq 1 ] && menu_window=$previous # cancel
[ $previous -eq 255 ] && break               # ESC

done

bspwm_installer(){
    git clone ${bspwm_link}
    cd ./bspwm
    make
    sudo make install
    cd ..
}

sxhkd_installer(){
    git clone ${sxhkd_link}
    cd ./sxhkd
    make
    sudo make install
    cd ..
}

lemon_ins_folder(){
    mkdir -p ${HOME}/.config/bspwm/panel
}

lemon_ins_example(){
    cd ./bspwm
    ls -la
    sudo cp ./examples/panel/panel ${HOME}/.config/bspwm/panel
    sudo cp ./examples/panel/panel_colors ${HOME}/.config/bspwm/panel
    sudo cp ./examples/panel/panel_bar ${HOME}/.config/bspwm/panel
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel_colors
    sudo chmod +x ${HOME}/.config/bspwm/panel/panel_bar
    cd ..
}

lemon_ins_export(){
    sudo echo export PANEL_FIFO="/tmp/panel-fifo" >> ${HOME}/.bashrc
}

lemonbar_installer(){
    #LemonBar Dependencies
    for dep in $lemonbar_dependencies
    do
        echo -e "\nInstalling $dep \n"
        git clone https://github.com/baskerville/$dep.git
        cd ./$dep
        make
        sudo make install
        cd ..
        echo -e "\n$dep Successfully Installed \n"
    done

    if [[ $lemon_cfg == *"folder"* ]]; then
        lemon_ins_folder
    fi
    if [[ $lemon_cfg == *"example"* ]]; then
        lemon_ins_example
    fi
    if [[ $lemon_cfg == *"export"* ]]; then
        lemon_ins_export
    fi
}

dependencies(){
    if [[ $wm == *"bspwm"* ]]; then
        sudo apt-get install ${bspwm_dependencies}
        bspwm_installer
        sxhkd_installer
        echo -e "\nBSPWM Successfully Installed \n"
        sleep 1
    fi

    if [[ ${bar} == *"LemonBar"* ]]; then
        echo -e "\nInstalling LemonBar \n"
        lemonbar_installer
    elif [[ $bar == *"Polybar"* ]]; then
        echo "installing Polybar dependencies";
    fi
}

main () {
    if [ -d "./build" ]; then
        cd ./build
    else
        mkdir ./build
        cd ./build
    fi
    dependencies
}

main
