#!/bin/bash

make O=out ARCH=arm64 my_xaga_defconfig \
    ARCH=arm64 \
    CC=~/clang-r416183b/bin/clang \
    AR=~/clang-r416183b/bin/llvm-ar \
    NM=~/clang-r416183b/bin/llvm-nm \
    LD=~/clang-r416183b/bin/ld.lld \
    OBJCOPY=~/clang-r416183b/bin/llvm-objcopy \
    OBJDUMP=~/clang-r416183b/bin/llvm-objdump \
    STRIP=~/clang-r416183b/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-


echo "=== 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=~/clang-r416183b/bin/clang \
    AR=~/clang-r416183b/bin/llvm-ar \
    NM=~/clang-r416183b/bin/llvm-nm \
    LD=~/clang-r416183b/bin/ld.lld \
    OBJCOPY=~/clang-r416183b/bin/llvm-objcopy \
    OBJDUMP=~/clang-r416183b/bin/llvm-objdump \
    STRIP=~/clang-r416183b/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-extra-args -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign"
  
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    ls out/arch/arm64/boot/
    exit 1
fi
