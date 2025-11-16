#!/bin/bash
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=~/clang-r365631c/bin/clang \
    AR=~/clang-r365631c/bin/llvm-ar \
    NM=~/clang-r365631c/bin/llvm-nm \
    LD=~/clang-r365631c/bin/ld.lld \
    OBJCOPY=~/clang-r365631c/bin/llvm-objcopy \
    OBJDUMP=~/clang-r365631c/bin/llvm-objdump \
    STRIP=~/clang-r365631c/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-extra-args -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign"
    
echo "=== 检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    exit 1
fi
