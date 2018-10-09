#!/bin/bash

function get_os() {

    declare -r OS_NAME="$(uname -s)"

    if [ "$OS_NAME" == "Darwin" ]; then
        echo "osx"
    elif [ "$OS_NAME" == "Linux" ]; then
        echo "linux"
    else
        echo "unknown"
    fi

}

function install_packages() {

    local package=$1

    os=$(get_os)
    if [ $os == "osx" ]; then
        source ./lib/osx.sh
        install_osx_packages $package
    elif [ $os == "linux" ]; then
        source ./lib/linux.sh
        install_linux_packages $package
    else
        error "OS $os not supported"
        exit;
    fi

}

function common_configuration() {

    echo 'PATH="$HOME/.GIS-lm-build/bin:$PATH"' >> ~/.profile

    # Default inotify files handle
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    # Default folder for develop
    mkdir -p ~/Develop/
    mkdir -p ~/.ssh/

    # Github blank ssh key
    
}
