#!/bin/bash
echo "=== 步骤1: 检查工具链 ==="
echo "=======检查cc：======="
~/clang-r365631c/bin/clang -v | grep "Android"
echo "=======检查ar：======="
~/clang-r365631c/bin/llvm-ar --version | grep "LLVM version"
echo "=======检查nm：======="
~/clang-r365631c/bin/llvm-nm --version | grep "LLVM version"
echo "=======检查ld：======="
~/clang-r365631c/bin/ld.lld -v
echo "=======查objcopy：======="
~/clang-r365631c/bin/llvm-objcopy --version | grep "LLVM version"
echo "=======检查objdump：======="
~/clang-r365631c/bin/llvm-objdump --version | grep "LLVM version"
echo "=======检查strip：======="
~/clang-r365631c/bin/llvm-strip --version | grep "LLVM version"
echo "=======检查aarch64-linux-gnu-gcc：======="
arm-linux-gnueabi-gcc -v 2>&1 | grep "gcc version"
echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v 2>&1 | grep "gcc version"
echo "====================检查环境结束==================="

echo "=== 步骤2: 开始编译 ==="
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
    
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    exit 1
fi
