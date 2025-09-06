#!/bin/sh

CURDIR=$(pwd)
ROOTFS="${CURDIR}/rootfs"

mkdir -p $ROOTFS/boot/grub

cp $CURDIR/kernel.elf $ROOTFS/boot/
cp $CURDIR/grub.cfg $ROOTFS/boot/grub

grub-mkrescue -o output.iso $ROOTFS
