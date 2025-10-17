#!/bin/bash

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置环境 ==="
export ARCH=arm64
export SUBARCH=arm64

# 使用 Proton Clang 工具链
export CC=/opt/proton-clang-20210522/bin/clang
export LD=/opt/proton-clang-20210522/bin/ld.lld
export AR=/opt/proton-clang-20210522/bin/llvm-ar
export CROSS_COMPILE=/opt/proton-clang-20210522/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/opt/proton-clang-20210522/bin/arm-linux-gnueabi-

# 修复 KCFLAGS - 不要使用多行，用单行
export KCFLAGS="-Wno-format -Wno-uninitialized -Wno-unused-variable -Wno-unused-but-set-variable -Wno-maybe-uninitialized -Wno-sign-compare -Wno-pointer-sign"

echo "=== 步骤3: 配置内核 ==="
make O=out my_polaris_defconfig
ls -l out/

echo "=== 步骤4: 开始编译（使用 Proton Clang）==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=/opt/proton-clang-20210522/bin/clang \
    LD=/opt/proton-clang-20210522/bin/ld.lld \
    CROSS_COMPILE=/opt/proton-clang-20210522/bin/aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=/opt/proton-clang-20210522/bin/arm-linux-gnueabi- \
    KCFLAGS="-Wno-format -Wno-uninitialized -Wno-unused-variable -Wno-unused-but-set-variable -Wno-maybe-uninitialized -Wno-sign-compare -Wno-pointer-sign"

echo "=== 步骤5：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi