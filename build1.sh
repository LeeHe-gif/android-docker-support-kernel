#!/bin/bash
echo "=== 步骤1: 设置proton-clang 13.0.0 ==="
git clone -b 12 --depth 1 https://github.com/kdrag0n/proton-clang.git
echo "=== 步骤2: 清理 ==="
make clean
make mrproper 

echo "=== 步骤3: 配置内核 ==="
make O=out polaris_defconfig

echo "=== 步骤4: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=proton-clang/bin/clang \
    AR=proton-clang/bin/llvm-ar \
    NM=proton-clang/bin/llvm-nm \
    OBJCOPY=proton-clang/bin/llvm-objcopy \
    OBJDUMP=proton-clang/bin/llvm-objdump \
    STRIP=proton-clang/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang"

echo "=== 步骤5：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
