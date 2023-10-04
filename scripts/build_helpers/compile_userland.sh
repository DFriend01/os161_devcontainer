#/bin/bash

# Compiles userland
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
