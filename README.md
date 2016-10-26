# tcnj_ic2
## Risc-V Toolchain Installation Instructions

First, ensure that all these packages are installed

$ sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc

Enter the top level of the git repo

$ export TOP=$(pwd)
$ cd $TOP/riscv-tools
$ git submodule update --init --recursive

$ export RISCV=$TOP/riscv

Now you need to set up your path, either in your bash profile or in the console

$ export PATH=$PATH:$RISCV/bin

$ ./build.sh

## Installing the RV32I compiler

$ sudo mkdir /opt/riscv32i
$ sudo chown $USER /opt/riscv32i

$ git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
$ cd riscv-gnu-toolchain-rv32i
$ git checkout 5b1febd

$ mkdir build; cd build
$ ../configure --with-xlen=32 --with-arch=I --prefix=/opt/riscv32i
$ make -j$(nproc)
