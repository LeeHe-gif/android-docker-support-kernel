#!/bin/bash

export ARCH=arm64
export CLANG_PATH=/home/runner/clang-r353983c/bin

make O=out my_803sh_defconfig \
    CC=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-gcc \
    AR=llvm-ar \
    NM=llvm-nm \
    LD=ld.lld \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip
    
make -j$(nproc --all) O=out \
    CC=/home/runner/aarch64-linux-android-4.9/bin/aarch64-linux-android-gcc \
    AR=llvm-ar \
    NM=llvm-nm \
    LD=ld.lld \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip
    
if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image 未生成"
    exit 1
fi
