#/bin/bash

# Configures a kernel
# Accepts one argument: The kernel to configure. Can be one of:
#   DUMBVM, DUMBVM-OPT, GENERIC, GENERIC-OPT, SYNCHPROBS
kernel=$1
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
echo "Done configuring the kernel"
