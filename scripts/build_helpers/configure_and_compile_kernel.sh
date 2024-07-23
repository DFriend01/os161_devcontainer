#!/bin/bash

function helpMessage() {
    echo "Usage: ./configure_and_compile_kernel.sh [OPTIONS]..."
    echo "Configures and compiles a kernel"
    echo "Example: ./configure_and_compile_kernel.sh -k DUMBVM"
    echo ""
    echo "Options"
    echo -e "\t-k: The kernel to configure and compile. Must be one of:" \
            "DUMBVM, DUMBVM-OPT, GENERIC, GENERIC-OPT, SYNCHPROBS"
    echo -e "\t-h: Display this message"
}

kernel=""

# Grab CLI arguments
while getopts ":hk:" flag; do
    case ${flag} in
        h) helpMessage; exit 0 ;;
        k) kernel=${OPTARG} ;;
        \?) echo "Invalid option: -${OPTARG}"; helpMessage; exit 1 ;;
        *) echo "Unhandled option: -${OPTARG}"; helpMessage; exit 1 ;;
    esac
done

# Assert that the kernel argument is non-empty
if [[ -z ${kernel} ]]; then
    echo "ERROR: Option -k is missing or argument value is empty"
    helpMessage
    exit 1
fi

prev_dir=$(pwd)
kernel_conf_dir=${OS161_SRC}/kern/conf
kernel_dir=${OS161_SRC}/kern/compile/${kernel}

if [[ -d ${kernel_conf_dir} && ! -z ${kernel} ]]; then
    cd ${kernel_conf_dir}
    ./config ${kernel}
else
    echo "Cannot configure kernel ${kernel} because ${kernel_dir} does not exist."
fi

if [[ -d ${kernel_dir} && ! -z ${kernel} ]]; then
    cd ${kernel_dir}
    bmake depend
    bmake -j$(nproc)
    bmake install
else
    echo "Cannot compile kernel ${kernel} because ${kernel_dir} does not exist."
fi

cd ${prev_dir}
echo "Done configuring and compiling the kernel"
