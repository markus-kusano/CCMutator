#!/bin/sh
# The script does the following:
# 1. Downloads LLVM 3.2 Source
# 2. Builds and installs LLVM 3.2 in ./llvm-3.2.src/install
# 3. Builds and install CCMutator in ./install

wget http://llvm.org/releases/3.2/llvm-3.2.src.tar.gz || exit 1
tar -xzvf llvm-3.2.src.tar.gz || exit 1
cd llvm-3.2.src 
mkdir ./install
./configure --prefix=`pwd`/install
make || exit 1
make install
cd ..
./configure --with-llvmsrc=`pwd`/llvm-3.2.src --with-llvmobj=`pwd`/install-3.2/ --prefix=`pwd`/install || exit 1
make || exit 1
make install 
