# SPDX-License-Identifier: BSD-2-Clause
.POSIX:
ARCH = i386
K = kernel
C = libc
KARCH = $(K)/arch/$(ARCH)
CARCH = $(C)/arch/$(ARCH)

AS = i686-elf-as
AR = i686-elf-ar
CC = i686-elf-cc
C3C = c3c

CFLAGS = -std=c99 -Wall -Wextra -Wpedantic -Werror
C3FLAGS = --quiet --obj-out kernel --output-dir kernel --no-headers
LDFLAGS = -ffreestanding -nostdlib -T $(KARCH)/linker.ld -Lkernel -lkernel -lgcc

BIN = kernel.elf
LIB = libc.a
LIBKERNEL = kernel/libkernel.a

OBJS = $(KARCH)/boot.o $(LIBKERNEL)

CRT = $(CARCH)/crti.o $(CARCH)/crtn.o
LIB_OBJS = 

all: $(BIN) $(LIB)

$(BIN): $(OBJS)
	@echo "  LD   $@"
	@$(CC) $(OBJS) $(LDFLAGS) -o $@
	@echo "========== kernel image compiled =========="

$(LIB): $(LIB_OBJS) $(CRT)
	@echo "  C3C  $@"
	@$(C3C) build libc --quiet --obj-out libc --output-dir libc --no-headers
	@rmdir build
	@echo "  AR   $@"
	@$(AR) rcs $@ $(LIB_OBJS) libc/*.o
	@echo "========== libc.a library compiled =========="

$(LIBKERNEL):
	@echo "  C3C  $@"
	@$(C3C) build libkernel $(C3FLAGS) -o $@
	@rmdir build

.c.o:
	@echo "  CC   $<"
	@$(CC) $(CFLAGS) -c $< -o $@

.s.o:
	@echo "  AS   $<"
	@$(AS) -c $< -o $@

clean:
	rm -f $(BIN) $(LIB) $(CRT) $(OBJS) $(LIB_OBJS) libc/*.o -r rootfs output.iso

iso: all
	./scripts/iso.sh

.PHONY: all clean iso
.SUFFIXES: .c .c3 .s
