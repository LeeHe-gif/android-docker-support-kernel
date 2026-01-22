#!/bin/bash

export ARCH=arm64
# export CLANG_PREBUILT_BIN=/home/runner/clang-r353983c/bin
export PATH=/home/runner/aarch64-linux-android-4.9/bin:$PATH

make O=out my_803sh_defconfig \
    CC=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-gcc \
    AR=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-ar \
    NM=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-nm \
    LD=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-ld \
    OBJCOPY=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-objcopy \
    OBJDUMP=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-objdump \
    STRIP=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-strip
    
make -j$(nproc --all) O=out \
    CC=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-gcc \
    AR=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-ar \
    NM=/home/runner/aarch64-linux-android-4.9/bin/arch64-linux-gnu-nm \
    LD=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-ld \
    OBJCOPY=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-objcopy \
    OBJDUMP=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-objdump \
    STRIP=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-strip
    
if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image 未生成"
    exit 1
fi
