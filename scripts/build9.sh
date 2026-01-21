#!/bin/bash

export CLANG_PREBUILT_BIN=/home/runner/clang-r383902/bin
export GCC_PREBUILT_BIN=/home/runner/aarch64-linux-android-4.9/bin
export PATH=$CLANG_PREBUILT_BIN:$GCC_PREBUILT_BIN:$PATH

make O=out my_803sh_defconfig \
    ARCH=arm64 \
    CC=clang \
    CLANG_TRIPLE=$CLANG_TRIPLE \
    CROSS_COMPILE=$CROSS_COMPILE \
    LLVM=1 \
    LLVM_IAS=1

make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=clang \
    CLANG_TRIPLE=$CLANG_TRIPLE \
    CROSS_COMPILE=$CROSS_COMPILE \
    LLVM=1 \
    LLVM_IAS=1
