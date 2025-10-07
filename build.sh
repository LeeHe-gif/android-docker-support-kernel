#!/bin/bash

# 清理构建环境
make clean && make mrproper && rm -rf out 

# 创建输出目录
mkdir -p out

# 设置架构
export ARCH=arm64
export SUBARCH=arm64

# 设置工具链路径
PATH="clang+llvm-14.0.6-aarch64-linux-gnu/bin/:$PATH"

# 配置内核
make O=out CC=clang polaris_defconfig ARCH=arm64

# 再次清理确保配置正确
make mrproper

# 编译内核
make -j$(nproc --all) O=out \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    CC=clang \
    AR=llvm-ar \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld