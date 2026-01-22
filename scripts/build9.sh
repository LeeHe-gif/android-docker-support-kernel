#!/bin/bash

export ARCH=arm64
export GCC_PREBUILT_BIN=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export PATH=$GCC_PREBUILT_BIN:$PATH

make O=out my_803sh_defconfig

make -j$(nproc --all) O=out
