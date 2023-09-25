
#/bin/bash

# This script only needs to be ran once even after rebuilding (as long as the osdev_home volume isn't deleted)
echo "Setting up devcontainer"

function install() {
    echo "Installing OS161 Dependencies..."
    prev_dir=$(pwd)
    cd $WORKSPACE_DIR/scripts
    bash ./cs161-ubuntu-darwin.sh

    cd $prev_dir

    echo "Fetching default sys161.conf file from the ECE server..."
    wget people.ece.ubc.ca/~os161/download/sys161.conf.sample -O ${WORKSPACE_DIR}/os161/sys161.conf
    echo "You may copy sys161.conf (or use your own) located in ${WORKSPACE_DIR}/os161 into your root directory with:"
    echo -e "\tcp \$WORKSPACE_DIR/os161/sys161.conf \$WORKSPACE_DIR/os161/root"
}

if [[ -d $HOME/tools ]]; then
    echo "~/tools already exists. Delete ~/tools if rebuilding is desired. Skipping build..."
else
    install
fi

echo "Done setup!"
