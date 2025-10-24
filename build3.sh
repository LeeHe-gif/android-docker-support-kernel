#!/bin/bash
echo "=== 步骤1: 设置 clang 14.0.2  ==="
git clone --depth 1 https://github.com/AOSP-12/prebuilts_clang_host_linux-x86_clang-r445002.git ~/prebuilts_clang_host_linux-x86_clang-r445002

export LD_LIBRARY_PATH="~/prebuilts_clang_host_linux-x86_clang-r445002/lib64:$LD_LIBRARY_PATH"

echo "=======检查cc：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/clang -v

echo "=======检查ar：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-ar --version

echo "=======检查nm：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-nm --version

echo "=======检查ld：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/ld.lld -v

echo "=======查objcopy：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-objcopy --version

echo "=======检查objdump：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-objdump --version

echo "=======检查strip：======="
~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-strip --version

echo "=======检查aarch64-linux-gnu-gcc：======="
aarch64-linux-gnu-gcc -v

echo "=======检查arm-linux-gnueabi-gcc：======="
arm-linux-gnueabi-gcc -v

echo "================检查环境结束================"

echo "=== 步骤2: 配置内核 ==="
mkdir out
cp arch/arm64/configs/my_alioth_defconfig out/.config

echo "=== 步骤3: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/clang \
    AR=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-ar \
    NM=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-nm \
    LD=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/ld.lld \
    OBJCOPY=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-objcopy \
    OBJDUMP=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-objdump \
    STRIP=~/prebuilts_clang_host_linux-x86_clang-r445002/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wmacro-redefined -Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang"
    
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz-dtb" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz-dtb 未生成"
    exit 1
fi
