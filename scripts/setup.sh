#/bin/bash

# This script only needs to be ran once even after rebuilding (as long as the osdev_home volume isn't deleted)
echo "Setting up devcontainer"

function install() {
    echo "Installing OS161 Dependencies..."
    prev_dir=$(pwd)
    cd $WORKSPACE_DIR/scripts
    bash ./cs161-ubuntu-darwin.sh
    cd $prev_dir
}

if [[ -d $HOME/tools ]]; then
    echo "~/tools already exists. Delete ~/tools if rebuilding is desired. Skipping build..."
else
    install
fi

if [[ ! -d ${WORKSPACE_DIR}/os161/root ]]; then
    mkdir -p ${WORKSPACE_DIR}/os161/root
fi

if [[ ! -f ${WORKSPACE_DIR}/os161/root/sys161.conf ]]; then
    echo "sys161.conf does not exist in root directory. Adding config file..."
    cp ${HOME}/sys161.conf ${WORKSPACE_DIR}/os161/root
else
    echo "sy161.conf already exists"
fi

echo "Done setup!"
