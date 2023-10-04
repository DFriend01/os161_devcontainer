#/bin/bash

# Configures the OS tree
# Accepts one optional argument: The absolute path to the os tree
ostree_path=$1
default_ostree_path=${WORKSPACE_DIR}/os161/root

prev_dir=$(pwd)

# If first argument empty, set to default path
if [[ -z ${ostree_path} ]]; then
    ostree_path=${default_ostree_path}
fi

# Set the ostree path
if [[ -d ${OS161_SRC} ]]; then
    cd ${OS161_SRC}
    ./configure --ostree=${ostree_path}
else
    echo "Cannot configure os tree because ${OS161_SRC} does not exist."
fi

cd ${prev_dir}
echo "Done configuring OS tree path"
