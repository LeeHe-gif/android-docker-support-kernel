#!/bin/bash
cd ~/android_kernel_xiaomi_sdm845
echo "===步骤1: 设置编译器==="
# 创建工具链目录
sudo mkdir -p /opt
sudo chmod 777 /opt
wget https://github.com/kdrag0n/proton-clang/archive/refs/tags/20210522.tar.gz
tar -xf 20210522.tar.gz
sudo chmod 777 proton-clang-20210522

echo "=== 步骤2: 清理 ==="
make clean
make mrproper 

echo "=== 步骤3: 配置内核 ==="
make O=out my_polaris_defconfig

echo "=== 步骤4: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=/opt/proton-clang-20210522/bin/clang \
    AR=/opt/proton-clang-20210522/bin/llvm-ar \
    NM=/opt/proton-clang-20210522/bin/llvm-nm \
    OBJCOPY=/opt/proton-clang-20210522/bin/llvm-objcopy \
    OBJDUMP=/opt/proton-clang-20210522/bin/llvm-objdump \
    STRIP=/opt/proton-clang-20210522/bin/llvm-strip \
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
