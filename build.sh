#!/bin/bash


KERNEL_NAME=malt-marble

export KERNEL_PATH=$PWD
export ANYKERNEL_PATH=$PWD/anykernel

if [ ! -d ~/clangx ]; then
	wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/428d18d9732aa7ebfcaed87a582d86155db878d4/clang-r416183b.tar.gz ~/clang-r416183b.tar.gz
	tar -xvf ~/clang-r416183b.tar.gz ~/clangx
fi
export PATH=~/clangx/bin:$PATH
read -p "Do you want to run 'make mrproper'? (y/n) " confirm
if [ "$confirm" = "y" ]; then
    make ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out mrproper
fi
make ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out marble_defconfig
make ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out -j$(nproc --all)

rm -rf $ANYKERNEL_PATH/Image
cp $KERNEL_PATH/out/arch/arm64/boot/Image $ANYKERNEL_PATH/

cd $ANYKERNEL_PATH
zip -r $KERNEL_NAME *
mv $KERNEL_NAME.zip $KERNEL_PATH/out/

cd $KERNEL_PATH
echo $KERNEL_NAME.zip
