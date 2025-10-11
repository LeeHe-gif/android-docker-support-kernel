#!/bin/bash

echo "=== 当前工作目录: $(pwd) ==="
echo "=== 内核源码目录内容 ==="
ls -la

echo "=== 步骤1: 清理 ==="
make clean || true
make mrproper || true
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置 Proton Clang 环境 ==="
export ARCH=arm64
export SUBARCH=arm64

# 设置 Proton Clang 路径
export CLANG_PATH=/opt/toolchains/proton-clang/bin
export PATH=$CLANG_PATH:$PATH

# 设置 LLVM 工具
export LLVM=1
export LLVM_IAS=1
export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip

# 设置交叉编译
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo "=== 检查工具链 ==="
clang --version | head -3
ld.lld --version | head -1
which clang
which ld.lld

echo "=== 步骤3: 配置内核 ==="
# 尝试不同的配置文件名
if [ -f "arch/arm64/configs/my_alioth_defconfig" ]; then
    echo "使用 my_alioth_defconfig"
    make O=out my_alioth_defconfig
elif [ -f "arch/arm64/configs/alioth_defconfig" ]; then
    echo "使用 alioth_defconfig"
    make O=out alioth_defconfig
elif [ -f "arch/arm64/configs/vendor/alioth_defconfig" ]; then
    echo "使用 vendor/alioth_defconfig"
    make O=out vendor/alioth_defconfig
else
    echo "❌ 未找到 alioth 配置文件，可用的配置文件:"
    find arch/arm64/configs/ -name "*alioth*" -o -name "*alioth*" 2>/dev/null || echo "未找到相关配置"
    exit 1
fi

echo "=== 步骤4: 开始编译（Proton Clang）==="
# 使用简单的 make 命令，让内核构建系统自动处理工具链
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="clang" \
    LD="ld.lld" \
    AR="llvm-ar" \
    NM="llvm-nm" \
    OBJCOPY="llvm-objcopy" \
    OBJDUMP="llvm-objdump" \
    STRIP="llvm-strip" \
    CROSS_COMPILE="aarch64-linux-gnu-" \
    CROSS_COMPILE_ARM32="arm-linux-gnueabi-" \
    CLANG_TRIPLE="aarch64-linux-gnu-" \
    LLVM=1 \
    LLVM_IAS=1 2>&1 | tee build.log

echo "=== 检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ Image.gz 编译成功"
    # 处理 dtb 文件
    if [ -f "out/arch/arm64/boot/dts/qcom/kona.dtb" ]; then
        cat out/arch/arm64/boot/Image.gz out/arch/arm64/boot/dts/qcom/kona.dtb > out/arch/arm64/boot/Image.gz-dtb
        echo "✅ Image.gz-dtb 生成成功 (使用 kona.dtb)"
    elif [ -f "out/arch/arm64/boot/dts/vendor/qcom/kona.dtb" ]; then
        cat out/arch/arm64/boot/Image.gz out/arch/arm64/boot/dts/vendor/qcom/kona.dtb > out/arch/arm64/boot/Image.gz-dtb
        echo "✅ Image.gz-dtb 生成成功 (使用 vendor/kona.dtb)"
    else
        echo "⚠️  未找到 dtb 文件，仅生成 Image.gz"
        cp out/arch/arm64/boot/Image.gz out/arch/arm64/boot/Image.gz-dtb
    fi
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    echo "检查编译日志中的错误信息:"
    tail -50 build.log | grep -i error || echo "未找到明确的错误信息"
    exit 1
fi

echo "=== Proton Clang 编译完成! ==="
