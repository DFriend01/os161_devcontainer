#!/bin/bash

function helpMessage() {
    echo "Usage: ./compile_userland.sh"
    echo "Compile userland"
}

# Grab CLI arguments
while getopts ":h" flag; do
    case ${flag} in
        h) helpMessage; exit 0 ;;
        \?) echo "Invalid option: -${OPTARG}"; helpMessage; exit 1 ;;
        *) echo "Unhandled option: -${OPTARG}"; helpMessage; exit 1 ;;
    esac
done

prev_dir=$(pwd)
if [[ -d ${OS161_SRC} ]]; then
    cd ${OS161_SRC}
    bmake -j$(nproc)
    bmake install
else
    echo "Cannot compile userland because ${OS161_SRC} does not exist."
fi

cd ${prev_dir}
echo "Done compiling userland"
