#!/bin/bash

mv clang-r416183b ~/clang-r416183b

echo "=== 步骤1：修复字符问题 ==="
dos2unix sound/soc/codecs/aw883xx/Kconfig
dos2unix drivers/vendor/common/touchscreen_v2/chipone_tddi_pad/Kconfig
dos2unix drivers/vendor/common/tfa9873/Kconfig
dos2unix drivers/vendor/common/sensor/sar/aw9610x/Kconfig
dos2unix drivers/vendor/soc/sprd/Kconfig
dos2unix drivers/vendor/common/touchscreen_v2/Kconfig
dos2unix drivers/vendor/common/sensor/sar/Kconfig
dos2unix drivers/vendor/common/zte_lcdbl/Kconfig

echo "" >> drivers/vendor/common/sensor/sar/Kconfig
echo "" >> drivers/vendor/common/zte_lcdbl/Kconfig
sed -i '82s/bool " /bool "/' drivers/vendor/common/touchscreen_v2/Kconfig

echo "=== 步骤2: 开始编译 ==="
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC=~/clang-r416183b/bin/clang \
    AR=~/clang-r416183b/bin/llvm-ar \
    NM=~/clang-r416183b/bin/llvm-nm \
    LD=~/clang-r416183b/bin/ld.lld \
    OBJCOPY=~/clang-r416183b/bin/llvm-objcopy \
    OBJDUMP=~/clang-r416183b/bin/llvm-objdump \
    STRIP=~/clang-r416183b/bin/llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-Wno-array-bounds -Wformat -Wsometimes-uninitialized -Wformat-extra-args -Wformat-security -Wunknown-warning-option -Wunused-result -Wuninitialized -Wno-error -Wno-pointer-sign"
    
echo "=== 步骤3：检查编译结果 ==="
if [ -f "out/arch/arm64/boot/Image.gz" ]; then
    echo "✅ 内核编译成功"
else
    echo "❌ 内核编译失败 - Image.gz 未生成"
    exit 1
fi
