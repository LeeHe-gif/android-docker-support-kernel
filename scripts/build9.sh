#!/bin/bash

export ARCH=arm64
export CLANG_PREBUILT_BIN=/home/runner/clang-r353983c/bin
export CROSS_COMPILE=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export PATH=/home/runner/aarch64-linux-android-4.9/bin:$PATH

echo "当前工具链:"
which aarch64-linux-android-gcc
aarch64-linux-android-gcc --version

make O=out my_803sh_defconfig \

make -j$(nproc --all) O=out \

if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image 未生成"
    exit 1
fi
