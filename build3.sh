#!/bin/bash

# 步骤1: 设置 clang 14.0.2
echo "=== 步骤1: 设置 clang 14.0.2  ==="
if [ ! -d "/home/runner/prebuilts_clang_host_linux-x86_clang-r445002" ]; then
    git clone https://github.com/AOSP-12/prebuilts_clang_host_linux-x86_clang-r445002 --depth=1 /home/runner/prebuilts_clang_host_linux-x86_clang-r445002
fi

# -- 新增：定义工具链的绝对路径 --
TOOLCHAIN_PATH="/home/runner/prebuilts_clang_host_linux-x86_clang-r445002"
export PATH="${TOOLCHAIN_PATH}/bin:$PATH"
export LD_LIBRARY_PATH="${TOOLCHAIN_PATH}/lib64:$LD_LIBRARY_PATH"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CROSS_COMPILE="aarch64-linux-gnu-"
export CROSS_COMPILE_ARM32="arm-linux-gnueabi-"

# 检查工具版本 (保持不变)
echo "=======检查cc：======="
clang --version -v
echo "=======检查ar：======="
llvm-ar --version
echo "=======检查nm：======="
llvm-nm --version
echo "=======检查ld：======="
ld.lld --version
echo "=======查objcopy：======="
llvm-objcopy --version
echo "=======检查objdump：======="
llvm-objdump --version
echo "=======检查strip：======="
llvm-strip --version
echo "=======检查aarch64-linux-gnu-gcc：======="
aarch64-linux-gnu-gcc -v
echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v
echo "================检查环境结束================"


# 步骤2: 配置内核 (保持不变)
echo "=== 步骤2: 配置内核 ==="
mkdir out
cp arch/arm64/configs/my_alioth_defconfig out/.config
ls -a out/
# 步骤3: 开始编译
echo "=== 步骤3: 开始编译 ==="
# -- 修改：在 make 命令中使用工具的绝对路径 --
make -j$(nproc --all) O=out \
    CC="${TOOLCHAIN_PATH}/bin/clang" \
    AR="${TOOLCHAIN_PATH}/bin/llvm-ar" \
    NM="${TOOLCHAIN_PATH}/bin/llvm-nm" \
    OBJCOPY="${TOOLCHAIN_PATH}/bin/llvm-objcopy" \
    OBJDUMP="${TOOLCHAIN_PATH}/bin/llvm-objdump" \
    STRIP="${TOOLCHAIN_PATH}/bin/llvm-strip" \
    LD="${TOOLCHAIN_PATH}/bin/ld.lld"

# 步骤4：检查编译结果 (保持不变)
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功 - Image.gz-dtb 已生成"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
