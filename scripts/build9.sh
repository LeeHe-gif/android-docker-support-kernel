#!/bin/bash

export CLANG_PATH=/home/runner/aarch64-linux-android-4.9/aarch64-linux-android/bin/
export GCC_PREBUILT_BIN=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export PATH=$CLANG_PATH:$GCC_PREBUILT_BIN:$PATH

make O=out my_803sh_defconfig \
    ARCH=arm64 \
    AR=ar \
    NM=nm \
    LD=ld \
    OBJCOPY=objcopy \
    OBJDUMP=objdump \
    STRIP=strip \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-



make -j$(nproc --all) O=out \
    ARCH=arm64 \
    AR=ar \
    NM=nm \
    LD=ld \
    OBJCOPY=objcopy \
    OBJDUMP=objdump \
    STRIP=strip \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    KCFLAGS="-Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-extra-args -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign"

if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image 未生成"
    exit 1
f
