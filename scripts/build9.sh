#!/bin/bash

export CLANG_PATH=/home/runner/clang-r353983c/bin
export PATH=$CLANG_PATH:$PATH

make O=out my_803sh_defconfig \
    ARCH=arm64 \
    CC=clang \
    AR=llvm-ar \
    NM=llvm-nm \
    LD=ld.lld \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-

make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=clang \
    AR=llvm-ar \
    NM=llvm-nm \
    LD=ld.lld \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-extra-args -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign"
