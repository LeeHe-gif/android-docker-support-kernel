#!/bin/bash
cd ~/android_kernel_xiaomi_sdm845

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置环境 ==="
export ARCH=arm64
export CROSS_COMPILE=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/opt/toolchains/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-

echo "=== 步骤3: 配置内核 ==="
make O=out my_polaris_defconfig

echo "=== 步骤4: 开始编译（纯GCC）==="
make -j$(nproc --all) O=out | tee log.txt

echo "=== 步骤5：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
