#/bin/bash

function helpMessage() {
    echo "Usage: ./build.sh [OPTIONS]..."
    echo "Builds OS161"
    echo "Example: ./build.sh -k DUMBVM"
    echo ""
    echo "Options"
    echo -e "\t-k: The kernel to configure and compile. Must be one of:" \
            "DUMBVM, DUMBVM-OPT, GENERIC, GENERIC-OPT, SYNCHPROBS"
    echo -e "\t-p: The absolute path to the OS tree (optional). Default: ${WORKSPACE_DIR}/os161/root"
    echo -e "\t-h: Display this message"
}

ostree_path=""
kernel=""

default_ostree_path=${WORKSPACE_DIR}/os161/root

# Grab CLI arguments
while getopts ":hk:p:" flag; do
    case ${flag} in
        h) helpMessage; exit 0 ;;
        k) kernel=${OPTARG} ;;
        p) ostree_path=${OPTARG} ;;
        \?) echo "Invalid option: -${OPTARG}"; helpMessage; exit 1 ;;
        *) echo "Unhandled option: -${OPTARG}"; helpMessage; exit 1 ;;
    esac
done

# If os tree path is empty, set to default path
if [[ -z ${ostree_path} ]]; then
    ostree_path=${default_ostree_path}
fi

# Perform the build process
scripts_directory=${WORKSPACE_DIR}/scripts
bash ${scripts_directory}/build_helpers/configure_os_tree.sh -p ${ostree_path}
bash ${scripts_directory}/build_helpers/compile_userland.sh
bash ${scripts_directory}/build_helpers/configure_and_compile_kernel.sh -k ${kernel}

echo "Build done"
