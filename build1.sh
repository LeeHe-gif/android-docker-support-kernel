#!/bin/bash
echo "=== 步骤1: 设置proton-clang 13.0.0 ==="
cd ~
git clone --depth 1 https://github.com/kdrag0n/proton-clang.git proton-clang-20210522
echo "=======检查cc：======="
~/proton-clang-20210522/bin/clang -v

echo "=======检查ar：======="
~/proton-clang-20210522/bin/llvm-ar --version

echo "=======检查nm：======="
~/proton-clang-20210522/bin/llvm-nm --version

echo "=======查objcopy：======="
~/proton-clang-20210522/bin/llvm-objcopy --version

echo "=======检查objdump：======="
~/proton-clang-20210522/bin/llvm-objdump --version

echo "=======检查strip：======="
~/proton-clang-20210522/bin/llvm-strip --version

echo "=======检查aarch64-linux-gnu-gcc：======="
aarch64-linux-gnu-gcc -v

echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v

# 验证编译器是否存在
if [ ! -f "~/proton-clang/bin/clang" ]; then
    echo "❌ 错误：clang编译器未找到"
    echo "请检查proton-clang是否正确下载和解压"
    exit 1
fi

cd ~/work/polaris-arrowos11-docker-support-kernel/polaris-arrowos11-docker-support-kernel/android_kernel_xiaomi_sm8250/

echo "=== 步骤2: 清理 ==="
make clean
make mrproper 

echo "=== 步骤3: 配置内核 ==="
export ARCH=arm64
make O=out alioth_defconfig

echo "=== 步骤4: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=~/proton-clang-20210522/bin/clang \
    AR=~/proton-clang-20210522/bin/llvm-ar \
    NM=~/proton-clang-20210522/bin/llvm-nm \
    OBJCOPY=~/proton-clang-20210522/bin/llvm-objcopy \
    OBJDUMP=~/proton-clang-20210522/bin/llvm-objdump \
    STRIP=~/proton-clang-20210522/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wformat -Wsometimes-uninitialized -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang" 
    
echo "=== 步骤5：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
