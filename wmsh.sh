#!/bin/bash

## Check variables
#WM
wm_bspwm_checked=OFF

#BAR
bar_lemonbar_checked=OFF
bar_polybar_checked=OFF

#POLYBAR_CONFIG
polybar_cfg_alsa_checked=OFF
polybar_cfg_pulseaudio_checked=OFF
polybar_cfg_network_checked=OFF
polybar_cfg_mpd_checked=OFF
polybar_cfg_git_checked=OFF
polybar_cfg_default_checked=OFF

## MENU
menu_window=welcome

while : ; do

    case "$menu_window" in
        welcome)
            menu_window=menu
            dialog --backtitle 'Window Manager Installer in Shell' \
                --msgbox 'Caution!' 0 0
            ;;
        menu)
            echo "$wm"
            previous=welcome
            menu=$( dialog --stdout \
                    --backtitle 'Window Manager Installer in Shell' \
                    --menu 'Menu' 0 0 0 \
                    1 'Window Manager'        \
                    2 'Bar' \
                    3 'SAIR')
            if [[ $menu == *"1"* ]]; then
                menu_window=wm_select
            elif [[ $menu == *"2"* ]]; then
                menu_window=bar_select
            elif [[ $menu == *"3"* ]]; then
                break
            fi
            ;;
        wm_select)
            menu_window=menu
            if [[ $wm == *"bspwm"* ]]; then
                wm_bspwm_checked=ON
            fi
            wm=$( dialog --stdout \
                    --backtitle 'Window Manager Installer in Shell' \
                    --radiolist 'Choose the Window Manager' 0 0 0 \
                    'bspwm' 'Binary Space Partitioning Window Manager' ${wm_bspwm_checked})
            ;;
        bar_select)
            menu_window=menu
            bar=$( dialog --stdout \
                    --backtitle 'Window Manager Installer in Shell' \
                    --radiolist 'Choose the Bar' 0 0 0 \
                    'LemonBar' 'Featherweight lemon-scented bar' ${bar_lemonbar_checked} \
                    'Polybar' 'A fast and easy-to-use status bar' ${bar_polybar_checked})
            if [[ $bar == *"LemonBar"* ]]; then
                bar_lemonbar_checked=ON
                bar_polybar_checked=OFF
            elif [[ $bar == *"Polybar"* ]]; then
                bar_polybar_checked=ON
                bar_lemonbar_checked=OFF
                menu_window=polybar_config
            fi
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

            if [[ $polybar_cfg == *"default"* ]]; then
                polybar_cfg_default_checked=ON;
                polybar_cfg_pulseaudio_checked=OFF;
                polybar_cfg_mpd_checked=OFF;
                polybar_cfg_git_checked=OFF;
            else
                polybar_cfg_default_checked=OFF;
            fi

            echo "$polybar_cfg"
            polybar_cfg=$( dialog --stdout \
                            --separate-output \
                            --backtitle 'Window Manager Installer in Shell' \
                            --checklist 'Polybar Support CFG' 0 0 0 \
                            'internal/alsa' 'alsalib' ${polybar_cfg_alsa_checked} \
                            'internal/pulseaudio' 'libpulse' ${polybar_cfg_pulseaudio_checked} \
                            'internal/network' 'libn1/libiw' ${polybar_cfg_network_checked} \
                            'internal/mpd' 'libmpdclient' ${polybar_cfg_mpd_checked} \
                            'internal/github' 'libcurl' ${polybar_cfg_git_checked} \
                            'default' 'pulseaudio, mpd, github' ${polybar_cfg_default_checked})
            menu_window=menu
            ;;

    esac

previous=$?
[ $previous -eq 1 ] && menu_window=$previous # cancel
[ $previous -eq 255 ] && break               # ESC

done


