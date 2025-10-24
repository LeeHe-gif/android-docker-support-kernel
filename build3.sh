#!/bin/bash
echo "=== 步骤1: 设置 clang 14.0.2 ==="

# 获取当前工作目录的绝对路径
CURRENT_DIR=$(pwd)
CLANG_PATH="$CURRENT_DIR/prebuilts_clang_host_linux-x86_clang-r445002"

git clone --depth 1 https://github.com/AOSP-12/prebuilts_clang_host_linux-x86_clang-r445002.git "$CLANG_PATH"

# 设置环境变量
export PATH="$CLANG_PATH/bin:$PATH"
export LD_LIBRARY_PATH="$CLANG_PATH/lib64:$LD_LIBRARY_PATH"

echo "=======检查cc：======="
$CLANG_PATH/bin/clang -v

echo "=======检查ar：======="
$CLANG_PATH/bin/llvm-ar --version

echo "=======检查nm：======="
$CLANG_PATH/bin/llvm-nm --version

echo "=======检查ld：======="
$CLANG_PATH/bin/ld.lld -v
which ld
which ld.lld

echo "=======查objcopy：======="
$CLANG_PATH/bin/llvm-objcopy --version

echo "=======检查objdump：======="
$CLANG_PATH/bin/llvm-objdump --version

echo "=======检查strip：======="
$CLANG_PATH/bin/llvm-strip --version

echo "=======检查aarch64-linux-gnu-gcc：======="
aarch64-linux-gnu-gcc -v

echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v

echo "================检查环境结束================"

echo "=== 步骤2: 配置内核 ==="
make O=out ARCH=arm64 my_alioth_defconfig \
    ARCH=arm64 \
    CC="$CLANG_PATH/bin/clang" \
    AR="$CLANG_PATH/bin/llvm-ar" \
    NM="$CLANG_PATH/bin/llvm-nm" \
    LD="$CLANG_PATH/bin/ld.lld" \
    OBJCOPY="$CLANG_PATH/bin/llvm-objcopy" \
    OBJDUMP="$CLANG_PATH/bin/llvm-objdump" \
    STRIP="$CLANG_PATH/bin/llvm-strip" \
    CROSS_COMPILE="aarch64-linux-gnu-" \
    CROSS_COMPILE_ARM32="arm-linux-gnueabi-"

echo "=== 步骤3: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="$CLANG_PATH/bin/clang" \
    AR="$CLANG_PATH/bin/llvm-ar" \
    NM="$CLANG_PATH/bin/llvm-nm" \
    LD="$CLANG_PATH/bin/ld.lld" \
    OBJCOPY="$CLANG_PATH/bin/llvm-objcopy" \
    OBJDUMP="$CLANG_PATH/bin/llvm-objdump" \
    STRIP="$CLANG_PATH/bin/llvm-strip" \
    CROSS_COMPILE="aarch64-linux-gnu-" \
    CROSS_COMPILE_ARM32="arm-linux-gnueabi-" \
    KCFLAGS="-Wmacro-redefined -Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang"
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
