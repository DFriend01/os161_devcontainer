#/bin/bash

# Most of the devcontainer is configured to use the "default" directory,
# so it's advised to not change it unless you really want to change it
function helpMessage() {
    echo "Usage: ./configure_os_tree.sh [OPTIONS]..."
    echo "Configures the OS Tree"
    echo "Example: ./configure_os_tree.sh -p /workspace/os161/root"
    echo ""
    echo "Options"
    echo -e "\t-p: The absolute path to the OS tree (optional). Default: ${WORKSPACE_DIR}/os161/root"
    echo -e "\t-h: Display this message"
}

ostree_path=""
default_ostree_path=${WORKSPACE_DIR}/os161/root

# Grab CLI arguments
while getopts ":hp:" flag; do
    case ${flag} in
        h) helpMessage; exit 0 ;;
        p) ostree_path=${OPTARG} ;;
        \?) echo "Invalid option: -${OPTARG}"; helpMessage; exit 1 ;;
        *) echo "Unhandled option: -${OPTARG}"; helpMessage; exit 1 ;;
    esac
done

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
