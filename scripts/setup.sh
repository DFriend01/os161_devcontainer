#/bin/bash

# This script only needs to be ran once even after rebuilding (as long as the osdev_home volume isn't deleted)
echo "Setting up devcontainer"

function install() {
    echo "Installing OS161 Dependencies..."
    prev_dir=$(pwd)
    cd $WORKSPACE_DIR/scripts
    bash ./cs161-ubuntu-darwin.sh

    # Probably should parameterize the darwin script to install in some specified directory
    # but this works for now
    sudo mv ~/tools $OS161_DEPENDENCIES_DIR

    cd $prev_dir
}

if [[ -d $OS161_DEPENDENCIES_DIR/tools ]]; then
    echo "${OS161_DEPENDENCIES_DIR}/tools already exists. Delete the tools directory" \
         "if rebuilding is desired. Skipping build..."
else
    install
fi

if [[ ! -d ${WORKSPACE_DIR}/os161/root ]]; then
    mkdir -p ${WORKSPACE_DIR}/os161/root
else
    echo "root directory already exists"
fi

if [[ ! -f ${WORKSPACE_DIR}/os161/root/sys161.conf ]]; then
    echo "sys161.conf does not exist in root directory. Adding config file..."
    cp ${HOME}/sys161.conf ${WORKSPACE_DIR}/os161/root
else
    echo "sy161.conf already exists"
fi

echo "Done setup!"
