#!/usr/bin/env bash

pkgs="bspwm sxhkd xdo sutils xtitle"

cl_urls="https://github.com/baskerville/bspwm
https://github.com/baskerville/sxhkd
https://github.com/baskerville/xdo
https://github.com/baskerville/xtitle
https://github.com/baskerville/sutils"

deps="xorg git build-essential clang cmake cmake-data pkg-config python3-sphinx rxvt-unicode xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev libcairo2-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-cursor-dev libasound2-dev alsa-oss pulseaudio libpulse-dev mpd libmpdclient-dev curl libcurl4-openssl-dev"

OS=$(lsb_release -si)

dependencies(){
    echo ""
    echo "Installing Dependencies..."
    echo ""
    sleep 2
    case $OS in
        Ubuntu|Debian)
        set -x
        sudo apt install $deps
    esac
    set +x
}

clone(){
    echo ""
    echo "Clonning Repo"
    echo "bspwm, polybar, sxhkd, xdo, sutils, xtitle"
    echo ""
    sleep 2
    
    for url in $cl_urls
    do
        set -x
        git clone $url
        set +x
    done
}

ins_polybar(){
    git clone "https://github.com/polybar/polybar"
    cd ./polybar
    chmod +x ./build.sh
    ./build.sh
    cd ..
}

ins(){
    echo ""
    echo "Starting installation of '$pkgs' !"
    echo ""
    sleep 2
    for pkg in $pkgs
    do
        set -x
        cd ./$pkg
        make
        sudo make install
        cd ..
        set +x
    done
}

config(){
    echo ""
    echo "Setting up Xsessions"
    echo ""
    sleep 1
    cd ~
    cd build/bspwm
    sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/
    echo ""
    echo "Setting up BSPWMRC & SXHKDRC"
    echo ""
    sleep 1
    mkdir -p ${HOME}/.config/{bspwm,sxhkd}
    cp examples/bspwmrc ~/.config/bspwm
    cp examples/sxhkdrc ~/.config/sxhkd
    cd ~
    cd build/
}

setting_files(){
    echo ""
    echo "Setting up BSPWMRC to work with Polybar"
    echo ""
    sleep 1
    echo "" >> ~/.config/bspwm/bspwmrc
    echo "pkill -x polybar" >> ~/.config/bspwm/bspwmrc
    echo "${HOME}/.config/polybar/launch.sh" >> ~/.config/bspwm/bspwmrc
}

cp_launch(){
    echo ""
    echo "Copying launch.sh (Polybar Launcher) to ~/.config/polybar/"
    echo ""
    sleep 1
    cd ~
    cd bsinstall/src/
    cp launch.sh ${HOME}/.config/polybar
    cd ~
    cd bsinstall/build
}

main(){
    mkdir -p ./build && cd ./build
    #dependencies
    #clone
    #ins
    #ins_polybar
    #cd ..
    #config
    #setting_files
    cp_launch
    echo ""
    echo "Finishing..."
    echo ""
    cd ~
    sleep 2
}

main
