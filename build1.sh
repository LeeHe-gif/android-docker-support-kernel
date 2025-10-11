#!/bin/bash

echo "=== 当前工作目录: $(pwd) ==="
echo "=== 内核源码目录内容 ==="
ls -la

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置 Clang 环境 ==="
export ARCH=arm64
export SUBARCH=arm64

# 设置 Android Clang 路径
export CLANG_PATH=/opt/toolchains/bin
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/opt/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/opt/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

# 设置 LLVM 工具
export LLVM=1
export LLVM_IAS=1
export CC=$CLANG_PATH/clang
export LD=$CLANG_PATH/ld.lld
export AR=$CLANG_PATH/llvm-ar
export NM=$CLANG_PATH/llvm-nm
export OBJCOPY=$CLANG_PATH/llvm-objcopy
export OBJDUMP=$CLANG_PATH/llvm-objdump
export STRIP=$CLANG_PATH/llvm-strip

echo "=== 检查工具链 ==="
$CLANG_PATH/clang --version | head -3
$CROSS_COMPILE-gcc --version | head -1

echo "=== 步骤3: 配置内核 ==="
# 尝试不同的配置文件名
if [ -f "arch/arm64/configs/my_alioth_defconfig" ]; then
    make O=out my_alioth_defconfig
elif [ -f "arch/arm64/configs/alioth_defconfig" ]; then
    make O=out alioth_defconfig
elif [ -f "arch/arm64/configs/vendor/alioth_defconfig" ]; then
    make O=out vendor/alioth_defconfig
else
    echo "❌ 未找到 alioth 配置文件，可用的配置文件:"
    find arch/arm64/configs/ -name "*alioth*" -o -name "*alioth*" 2>/dev/null || echo "未找到相关配置"
    exit 1
fi

echo "=== 步骤4: 开始编译（Android Clang）==="
# 使用 Clang 编译，启用 LLVM Integrated Assembler
make -j$(nproc --all) O=out \
    CC="$CLANG_PATH/clang" \
    LD="$CLANG_PATH/ld.lld" \
    AR="$CLANG_PATH/llvm-ar" \
    NM="$CLANG_PATH/llvm-nm" \
    OBJCOPY="$CLANG_PATH/llvm-objcopy" \
    OBJDUMP="$CLANG_PATH/llvm-objdump" \
    STRIP="$CLANG_PATH/llvm-strip" \
    CROSS_COMPILE="$CROSS_COMPILE" \
    CROSS_COMPILE_ARM32="$CROSS_COMPILE_ARM32" \
    CLANG_TRIPLE="aarch64-linux-gnu-" \
    LLVM=1 \
    LLVM_IAS=1 2>&1 | tee build.log

echo "=== 检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ Image.gz 编译成功"
    # 处理 dtb 文件
    if [ -f "out/arch/arm64/boot/dts/qcom/kona.dtb" ] || [ -f "out/arch/arm64/boot/dts/vendor/qcom/kona.dtb" ]; then
        cat out/arch/arm64/boot/Image.gz out/arch/arm64/boot/dts/qcom/kona.dtb > out/arch/arm64/boot/Image.gz-dtb 2>/dev/null || \
        cat out/arch/arm64/boot/Image.gz out/arch/arm64/boot/dts/vendor/qcom/kona.dtb > out/arch/arm64/boot/Image.gz-dtb
        echo "✅ Image.gz-dtb 生成成功"
    else
        echo "⚠️  未找到 dtb 文件，仅生成 Image.gz"
        cp out/arch/arm64/boot/Image.gz out/arch/arm64/boot/Image.gz-dtb
    fi
else
    echo "❌ 内核编译失败"
    exit 1
fi

echo "=== Clang 编译完成! ==="