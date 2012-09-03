#!/bin/bash

set -e

# Adjust path to toolchain!!
export CROSS_COMPILE="/home/Android/cm9/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
export KBUILD_BUILD_VERSION="OiSiS"
export LOCALVERSION="-beta-03"

#which ccache >/dev/null 2>&1
#if [ $? -eq 0 ]; then
#	export CROSS_COMPILE="ccache $CROSS_COMPILE"
#fi

cpus=$(grep "^processor" /proc/cpuinfo | wc -l)

usage()
{
	echo "Usage: build.sh <model> <project>"
	echo "Usage: build.sh clean"
	echo "  eg. build.sh palladio cm9"
	exit 1
}

opt_clean=""
if [ "$1" = "clean" ]; then
	make clean
	exit 0
fi

if [ "$#" -ne 2 ]; then
	usage
fi

model="$1"
project="$2"

if [ ! -f "arch/arm/configs/cyanogenmod_${model}_defconfig" ]; then
	echo "Cannot find config"
	exit 1
fi
if [ ! -d "./initramfs" ]; then
	echo "Cannot find initramfs"
	exit 1
fi

if [ ! -f ".config" -o "$model" != "$lastmodel" ]; then
	make cyanogenmod_${model}_defconfig
fi

initramfsdir=$(grep "^CONFIG_INITRAMFS_SOURCE" .config | \
	cut -d'=' -f2 | sed 's/"//g')
if [ -z "$initramfsdir" ]; then
	echo "Cannot find initramfs dir in config"
	exit 1
fi

rm -rf "$initramfsdir"
mkdir -p "$initramfsdir"
if [ -d "initramfs/common" ]; then
	cp -a initramfs/common/* "$initramfsdir"
fi
cp -a initramfs/${project}/* "$initramfsdir"

make -j${cpus}
mkdir -p "$initramfsdir/lib/modules"
cp $(find . -name "*.ko" | grep -v "$initramfsdir") "$initramfsdir/lib/modules"
make -j${cpus}
cp arch/arm/boot/zImage kernel-${model}-${project}.bin
md5sum kernel-${model}-${project}.bin
cp arch/arm/boot/zImage ./
tar -cf ./zImage.tar zImage
rm -f ./zImage
