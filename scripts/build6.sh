echo "=== 步骤1: 设置 gcc 10.3 ==="
cd ~
mkdir ToolChains
wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
tar -xJf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz -C ToolChains
cd ToolChains
mv  gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu gcc-arm-10.3

cd /home/runner/work/android-docker-support-kernel/android-docker-support-kernel/kernel_source

echo "=== 步骤1: 配置内核 ==="
make O=out ARCH=arm64 my_kirin970_defconfig \
    ARCH=arm64 \
    AR=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ar \
    NM=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/nm \
    LD=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ld \
    OBJCOPY=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objcopy \
    OBJDUMP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objdump \
    STRIP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/strip \
    CROSS_COMPILE=~/ToolChains/gcc-arm-10.3/bin/aarch64-none-linux-gnu-

echo "=== 步骤3: 开始编译内核 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    AR=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ar \
    NM=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/nm \
    LD=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ld \
    OBJCOPY=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objcopy \
    OBJDUMP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objdump \
    STRIP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/strip \
    CROSS_COMPILE=~/ToolChains/gcc-arm-10.3/bin/aarch64-none-linux-gnu-

echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    exit 1
fi
