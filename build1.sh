#!/bin/bash
cd ~/android_kernel_xiaomi_alioth

echo "=== 步骤1: 清理 ==="
make clean
make mrproper 
rm -rf out 
mkdir -p out

echo "=== 步骤2: 设置环境 ==="
export ARCH=arm64
export CROSS_COMPILE=/opt/aarch64-linux-android-4.9/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/opt/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-gnueabi-

# 添加编译选项来忽略警告
export KCFLAGS="-Wno-format -Wno-uninitialized -Wno-unused-variable -Wno-unused-but-set-variable -Wno-maybe-uninitialized -Wno-sign-compare"

echo "=== 步骤3: 配置内核 ==="
make O=out my_alioth_defconfig

echo "=== 步骤4: 开始编译（纯GCC）==="
make -j$(nproc --all) O=out

echo "=== 编译完成! ==="
