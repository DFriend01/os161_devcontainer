
#/bin/bash

# This script only needs to be ran once even after rebuilding (as long as the osdev_home volume isn't deleted)
echo "Setting up devcontainer"

function install() {
    echo "Installing OS161 Dependencies..."
    prev_dir=$(pwd)
    cd $WORKSPACE_DIR/scripts
    bash ./cs161-ubuntu-darwin.sh

    cd $prev_dir

    echo "Adding OS161 dependencies to PATH..."
    echo "PATH=$HOME/tools/os161/bin:$HOME/tools/sys161/bin:$PATH >> $HOME/.bashrc"
}

if [[ -d $HOME/tools ]]; then
    echo "~/tools already exists. Delete ~/tools if rebuilding is desired. Skipping build..."
else
    install
fi

source $HOME/.bashrc
echo "Done setup!"
