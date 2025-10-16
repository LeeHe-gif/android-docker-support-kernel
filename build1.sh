#!/bin/bash
cd ~/android_kernel_xiaomi_alioth

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置环境 ==="
export ARCH=arm64
export CC=/opt/proton-clang-20210522/bin/clang
export AR=/opt/proton-clang-20210522/bin/llvm-ar
export NM=/opt/proton-clang-20210522/bin/llvm-nm
export OBJCOPY=/opt/proton-clang-20210522/bin/llvm-objcopy
export OBJDUMP=/opt/proton-clang-20210522/bin/llvm-objdump
export STRIP=/opt/proton-clang-20210522/bin/llvm-strip
export CROSS_COMPILE=/opt/proton-clang-20210522/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/proton-clang-20210522/bin/arm-linux-gnueabi-

# 添加编译选项来忽略警告
export KCFLAGS="
-Wformat
-Wno-format
-Wno-uninitialized
-Wno-unused-variable
-Wno-unused-but-set-variable
-Wno-maybe-uninitialized
-Wno-sign-compare -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
"

echo "=== 步骤3: 配置内核 ==="
make O=out alioth_defconfig

echo "=== 步骤4: 开始编译（纯GCC）==="
make -j$(nproc --all) O=out

echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ Image.gz 编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
