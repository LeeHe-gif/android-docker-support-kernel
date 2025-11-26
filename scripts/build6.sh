

make -j$(nproc --all) O=out \
    ARCH=arm64 \
    AR=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ar \
    NM=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/nm \
    LD=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/ld \
    OBJCOPY=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objcopy \
    OBJDUMP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/objdump \
    STRIP=~/ToolChains/gcc-arm-10.3/aarch64-none-linux-gnu/bin/strip \
    CROSS_COMPILE=~/ToolChains/gcc-arm-10.3/bin/aarch64-none-linux-gnu-
