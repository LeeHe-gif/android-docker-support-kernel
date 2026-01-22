#!/bin/bash

export ARCH=arm64
export CLANG_PATH=/home/runner/aarch64-linux-android/bin/
export GCC_PREBUILT_BIN=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export PATH=$CLANG_PATH:$GCC_PREBUILT_BIN:$PATH

make O=out my_803sh_defconfig

make -j$(nproc --all) O=out
