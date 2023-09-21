#/bin/bash

SYS161="sys161-2.0.3"
BINUTILS161="binutils-2.24+os161-2.1"
GCC161="gcc-4.8.3+os161-2.1"
GDB161="gdb-7.8+os161-2.1"
#MIRROR="http://www.eecs.harvard.edu/~dholland/os161/download"
#MIRROR="http://www.ece.ubc.ca/~os161/download"
MIRROR="https://people.ece.ubc.ca/~os161/download"

#echo '*** Updating appliance ***'
#update50

#echo '*** Installing Ubuntu packages ***'
#sudo apt-get -y install bmake ncurses-dev libmpc-dev

mkdir -p $HOME/tools/os161/bin
mkdir -p $HOME/tools/sys161/bin
cd ~/tools

echo '*** Downloading OS/161 toolchain ***'
wget $MIRROR/$BINUTILS161.tar.gz
wget $MIRROR/$GCC161.tar.gz
wget $MIRROR/$GDB161.tar.gz
wget $MIRROR/$SYS161.tar.gz

echo '*** Unpacking OS/161 toolchain ***'
for file in *.tar.gz; do  
    tar -xzf $file
    rm -f $file
done

PRE_CC=$CC
PRE_CFLAGS=$CFLAGS
CC=gcc
CFLAGS=

nproc=$(nproc)

echo '*** Building binutils ***'
cd $BINUTILS161
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=$HOME/tools/os161 2>&1 | tee ../binutils.log
make -j$nproc 2>&1 | tee -a ../binutils.log
make install 2>&1 | tee -a ../binutils.log
cd ..
echo '*** Finished building binutils ***'
rm -rf $BINUTILS161

echo '*** Building gcc ***'
PATH=$HOME/tools/sys161/bin:$HOME/tools/os161/bin:$PATH
export PATH
cd $GCC161
find . -name '*.info' | xargs touch
touch intl/plural.c
mkdir ../gcc-build
cd ../gcc-build
../$GCC161/configure --enable-languages=c,lto -nfp --disable-shared --disable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx --disable-nls --target=mips-harvard-os161 --prefix=$HOME/tools/os161 2>&1 | tee ../gcc.log
make -j$nproc 2>&1 | tee -a ../gcc.log
make install 2>&1 | tee -a ../gcc.log
cd ..
echo '*** Finished building gcc ***'
rm -rf $GCC161
rm -rf gcc-build

echo '*** Building gdb ***'
cd $GDB161
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --target=mips-harvard-os161 --prefix=$HOME/tools/os161 --disable-werror --disable-sim 2>&1 | tee ../gdb.log
make -j$nproc 2>&1 | tee -a ../gdb.log
make install 2>&1 | tee -a ../gdb.log
cd ..
echo '*** Finished building gdb ***'
rm -rf $GDB161

echo '*** Building System/161 ***'
cd $SYS161
./configure --prefix=$HOME/tools/sys161 mipseb 2>&1 | tee ../sys161.log
make -j$nproc 2>&1 | tee -a ../sys161.log
make install 2>&1 | tee -a ../sys161.log
cd ..
mv $SYS161 sys161
echo '*** Finished building System/161 ***'

cd os161/bin
for file in *; do
	ln -s $file ${file:13}
done
cd ../..

cd ~
echo 'PATH=$HOME/tools/sys161/bin:$HOME/tools/os161/bin:$PATH' >> $HOME/.bashrc
echo 'set path = ($path $HOME/tools/os161/bin $HOME/tools/sys161/bin)' >> $HOME/.cshrc

CC=$PRE_CC
CFLAGS=$PRE_CFLAGS
echo '*** Done ***'
