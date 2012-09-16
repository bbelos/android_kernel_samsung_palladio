#!/bin/bash

set -e

# Adjust path to your toolchain.
TOOLCHAIN=CROSS_COMPILE="/home/isaac/cm9/system/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi"

echo "Cleaning..."

make $TOOLCHAIN- mrproper

echo "Cleaning Finished!!"
