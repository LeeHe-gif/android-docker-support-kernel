#!/bin/bash

cd kernel_source

# 清理
make clean && make mrproper
rm -rf out
mkdir -p out

# 使用 Clang 可以避免很多工具链问题
export ARCH=arm64

# 主机工具使用系统 gcc
export HOSTCC=gcc
export HOSTCXX=g++
export HOSTLD=ld

# 目标编译使用 Clang
export CC=/home/runner/clang-r353983c/bin/clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-

# 设置 binutils
export LD=aarch64-linux-gnu-ld
export AR=aarch64-linux-gnu-ar
export NM=aarch64-linux-gnu-nm
export STRIP=aarch64-linux-gnu-strip
export OBJCOPY=aarch64-linux-gnu-objcopy
export OBJDUMP=aarch64-linux-gnu-objdump

echo "=== 工具检查 ==="
echo "Clang: $($CC --version | head -1)"
echo "主机 GCC: $(gcc --version | head -1)"
echo "目标 LD: $(which $LD)"

# 生成配置
make O=out my_803sh_defconfig \
    HOSTCC="$HOSTCC" \
    HOSTCXX="$HOSTCXX"

# 修复配置
cd out
echo "修复配置..."
# 设置 Clang
echo "CONFIG_CC_IS_CLANG=y" >> .config
# 修复栈保护
sed -i 's/CONFIG_CC_STACKPROTECTOR_STRONG=y/# CONFIG_CC_STACKPROTECTOR_STRONG is not set/' .config || true
echo "CONFIG_CC_STACKPROTECTOR=y" >> .config
cd ..

# 编译
make -j$(nproc --all) O=out \
    HOSTCC="$HOSTCC" \
    HOSTCXX="$HOSTCXX" \
    CC="$CC" \
    CLANG_TRIPLE="$CLANG_TRIPLE" \
    LD="$LD" \
    AR="$AR" \
    NM="$NM" \
    STRIP="$STRIP" \
    OBJCOPY="$OBJCOPY" \
    OBJDUMP="$OBJDUMP"

# 检查
if [ -f "out/arch/arm64/boot/Image" ]; then
    echo "✅ 内核编译成功"
    exit 0
else
    echo "❌ 内核编译失败"
    exit 1
fi
