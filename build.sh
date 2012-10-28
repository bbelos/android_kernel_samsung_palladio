#!/bin/bash

set -e

# Adjust path to toolchain!!
export CROSS_COMPILE="/home/isaac/cm9/system/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
export KBUILD_BUILD_VERSION="Nebula"
export LOCALVERSION="RC1"

make cyanogenmod_palladio_defconfig

# Adjust this for your computer processing power.
make -j3

# For the zImage to be at the root of your kernel folder after compiling.
cp arch/arm/boot/zImage ./
