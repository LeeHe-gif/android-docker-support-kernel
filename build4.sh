#!/bin/bash
echo "=== 步骤1: 设置 clang 19.0.1 ==="
cd ~
wget -q https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-12.1.0_r26/clang-r416183b.tar.gz
mkdir clang-r416183b
tar -xf clang-r416183b.tar.gz -C clang-r416183b

echo "=======检查cc：======="
~/clang-r416183b/bin/clang -v

echo "=======检查ar：======="
~/clang-r416183b/bin/llvm-ar --version

echo "=======检查nm：======="
~/clang-r416183b/bin/llvm-nm --version

echo "=======检查ld：======="
~/clang-r416183b/bin/ld.lld -v

echo "=======查objcopy：======="
~/clang-r416183b/bin/llvm-objcopy --version

echo "=======检查objdump：======="
~/clang-r416183b/bin/llvm-objdump --version

echo "=======检查strip：======="
~/clang-r416183b/bin/llvm-strip --version

echo "=======检查aarch64-linux-gnu-gcc：======="
aarch64-linux-gnu-gcc -v

echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v

echo "====================检查环境结束==================="

echo "=== 步骤2: 配置内核 ==="
cd /home/runner/work/android-docker-support-kernel/android-docker-support-kernel/kernel_source
mkdir out
cp arch/arm64/configs/test_U30Air_defconfig out/.config

echo "=== 步骤3: 开始编译 ==="
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
    exit 1
fi
