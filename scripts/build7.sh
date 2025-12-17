echo "=== 步骤1: 配置内核 ==="
make O=out ARCH=arm64 my_xaga_defconfig \
    ARCH=arm64 \
    AR=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ar \
    NM=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/nm \
    LD=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ld \
    OBJCOPY=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objcopy \
    OBJDUMP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objdump \
    STRIP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-
echo "=== 步骤3: 开始编译内核 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    AR=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ar \
    NM=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/nm \
    LD=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ld \
    OBJCOPY=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objcopy \
    OBJDUMP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objdump \
    STRIP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-
echo "=== 步骤4：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    ls out/arch/arm64/boot/
    exit 1
fi
