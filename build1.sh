#!/bin/bash

echo "=== 当前工作目录: $(pwd) ==="

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置 Proton Clang 环境 ==="
export ARCH=arm64
export SUBARCH=arm64

# 设置 Proton Clang 路径
export CLANG_PATH=/opt/toolchains/proton-clang/bin
export CC=$CLANG_PATH/clang
export LD=$CLANG_PATH/ld.lld
export AR=$CLANG_PATH/llvm-ar

# 使用 Clang 的内置交叉编译功能，不需要单独的 GCC
export LLVM=1
export LLVM_IAS=1

echo "=== 检查工具链 ==="
$CLANG_PATH/clang --version | head -3

echo "=== 步骤3: 配置内核 ==="
if [ -f "arch/arm64/configs/my_alioth_defconfig" ]; then
    make O=out my_alioth_defconfig
elif [ -f "arch/arm64/configs/alioth_defconfig" ]; then
    make O=out alioth_defconfig
elif [ -f "arch/arm64/configs/vendor/alioth_defconfig" ]; then
    make O=out vendor/alioth_defconfig
else
    echo "❌ 未找到 alioth 配置文件"
    find arch/arm64/configs/ -name "*alioth*" 2>/dev/null || echo "未找到相关配置"
    exit 1
fi

echo "=== 步骤4: 开始编译（Proton Clang）==="
make -j$(nproc --all) O=out \
    CC="ccache $CLANG_PATH/clang" \
    LD="$CLANG_PATH/ld.lld" \
    AR="$CLANG_PATH/llvm-ar" \
    LLVM=1 \
    LLVM_IAS=1 2>&1 | tee build.log

echo "=== 检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 编译成功"
    # 处理 dtb 文件
    find out/arch/arm64/boot/dts -name "*.dtb" | head -1 | while read dtb; do
        cat out/arch/arm64/boot/Image.gz "$dtb" > out/arch/arm64/boot/Image.gz-dtb
        echo "✅ Image.gz-dtb 生成成功"
        break
    done
    if [ ! -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
        cp out/arch/arm64/boot/Image.gz out/arch/arm64/boot/Image.gz-dtb
    fi
else
    echo "❌ 内核编译失败"
    exit 1
fi

echo "=== Proton Clang 编译完成! ==="