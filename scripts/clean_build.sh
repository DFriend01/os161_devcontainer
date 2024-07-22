#!/bin/bash

# Removes all generated files
prev_dir=$(pwd)

# Clean src directory
if [[ -d ${OS161_SRC} ]]; then
    echo "Cleaning src directory"
    cd ${OS161_SRC}
    bmake clean
    bmake distclean
else
    echo "Cannot clean ${OS161_SRC}. It does not exist."
fi

# Clean kern/compile directories
compile_directory=${OS161_SRC}/kern/compile
if [[ -d ${compile_directory} ]]; then
    cd ${compile_directory}
    kernel_directories=$(ls -d *)

    for subdir in ${kernel_directories}; do
        echo "Cleaning ${subdir}"
        cd ${compile_directory}/${subdir}
        bmake clean
    done
else
    echo "Cannot clean ${compile_directory}. It does not exist."
fi

cd ${prev_dir}

echo "Clean done!"
