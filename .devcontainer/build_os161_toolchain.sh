#!/bin/bash
set -e

function helpMessage() {
    echo "Usage: ./build_os161_toolchain.sh [OPTIONS]..."
    echo "Builds the OS161 toolchain"
    echo "Example: ./build_os161_toolchain.sh -i ${HOME}"
    echo ""
    echo "Options"
    echo -e "\t-i: The absolute path to store the toolchain (optional). Default: ${HOME}"
    echo -e "\t-m: The URL to the mirror site containing the toolchain archives (optional). Default: http://os161.org/download"
    echo -e "\t-j: The number of processors to build with (optional). Default: $(nproc)"
    echo -e "\t-h: Display this message"
}

# Grab CLI arguments
INSTALL_DIR=""
MIRROR=""
NPROCS=""
while getopts ":hi:m:j:" flag; do
    case ${flag} in
        h) helpMessage; exit 0 ;;
        i) INSTALL_DIR=${OPTARG} ;;
        m) MIRROR=${OPTARG} ;;
        j) NPROCS=${OPTARG} ;;
        \?) echo "Invalid option: -${OPTARG}"; helpMessage; exit 1 ;;
        *) echo "Unhandled option: -${OPTARG}"; helpMessage; exit 1 ;;
    esac
done

# Validate arguments and set default values if necessary
if [ -z ${INSTALL_DIR} ]; then
    INSTALL_DIR=${HOME}
fi

if [ -z ${MIRROR} ]; then
    MIRROR="http://os161.org/download"
    # MIRROR="https://people.ece.ubc.ca/~os161/download"
fi

if [ -z ${NPROCS} ]; then
    NPROCS=$(nproc)
elif [[ ! ${NPROCS} =~ ^\d+$ ]] || [ ${NPROCS} -le 0 ] || [ ${NPROCS} -gt $(nproc) ] ; then
    echo "ERROR: Argument -j must be an integer 0 < ARG <= $(nproc), but was ${NPROCS}"
    exit 1
fi

# OS161 Toolchain variables
SYS161="sys161-2.0.3"
BINUTILS161="binutils-2.24+os161-2.1"
GCC161="gcc-4.8.3+os161-2.1"
GDB161="gdb-7.8+os161-2.1"

# Dependency installation already completed in the Dockerfile
# echo '*** Updating appliance ***'
# sudo apt update

# echo '*** Installing Ubuntu packages ***'
# sudo apt install -y bmake build-essential ncurses-dev libmpc-dev

mkdir -p ${INSTALL_DIR}/tools/os161/bin
mkdir -p ${INSTALL_DIR}/tools/sys161/bin
cd ${INSTALL_DIR}/tools

echo '*** Downloading OS/161 toolchain ***'
wget "${MIRROR}/${BINUTILS161}.tar.gz"
wget "${MIRROR}/${GCC161}.tar.gz"
wget "${MIRROR}/${GDB161}.tar.gz"
wget "${MIRROR}/${SYS161}.tar.gz"

echo '*** Unpacking OS/161 toolchain ***'
for file in *.tar.gz; do  
    tar -xzf ${file}
    rm -f ${file}
done

PRE_CC=${CC}
PRE_CFLAGS=${CFLAGS}
CC=gcc
CFLAGS=
export CXXFLAGS=-std=gnu++11

echo '*** Building binutils ***'
cd ${BINUTILS161}
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=${INSTALL_DIR}/tools/os161 2>&1 | tee ../binutils.log
make -j${NPROCS} 2>&1 | tee -a ../binutils.log
make install 2>&1 | tee -a ../binutils.log
cd ..
echo '*** Finished building binutils ***'
rm -rf ${BINUTILS161}

echo '*** Building gcc ***'
PATH=${INSTALL_DIR}/tools/sys161/bin:${INSTALL_DIR}/tools/os161/bin:${PATH}
export PATH
cd ${GCC161}
find . -name '*.info' | xargs touch
touch intl/plural.c
mkdir ../gcc-build
cd ../gcc-build
../${GCC161}/configure --enable-languages=c,lto -nfp --disable-shared --disable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx --disable-nls --target=mips-harvard-os161 --prefix=${INSTALL_DIR}/tools/os161 2>&1 | tee ../gcc.log
make -j${NPROCS} 2>&1 | tee -a ../gcc.log
make install 2>&1 | tee -a ../gcc.log
cd ..
echo '*** Finished building gcc ***'
rm -rf ${GCC161}
rm -rf gcc-build

echo '*** Building gdb ***'
cd ${GDB161}
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --target=mips-harvard-os161 --prefix=${INSTALL_DIR}/tools/os161 --disable-werror --disable-sim --with-python=no 2>&1 | tee ../gdb.log
make -j${NPROCS} 2>&1 | tee -a ../gdb.log
make install 2>&1 | tee -a ../gdb.log
cd ..
echo '*** Finished building gdb ***'
rm -rf ${GDB161}

echo '*** Building System/161 ***'
cd ${SYS161}

# Mark as extern to fix multiple definition error
sed -i 's/uint64_t extra_selecttime;/extern uint64_t extra_selecttime;/' include/onsel.h

./configure --prefix=${INSTALL_DIR}/tools/sys161 mipseb 2>&1 | tee ../sys161.log
make -j${NPROCS} 2>&1 | tee -a ../sys161.log
make install 2>&1 | tee -a ../sys161.log
cd ..
mv ${SYS161} sys161
echo '*** Finished building System/161 ***'

cd os161/bin
for file in *; do
	ln -s ${file} ${file:13}
done
cd ../..

# Paths are already set in Dockerfile
# cd ~
# echo 'PATH=${INSTALL_DIR}/tools/sys161/bin:${INSTALL_DIR}/tools/os161/bin:${PATH}' >> ${HOME}/.bashrc

CC=${PRE_CC}
CFLAGS=${PRE_CFLAGS}
echo '*** Done ***'
