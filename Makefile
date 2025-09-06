# SPDX-License-Identifier: BSD-2-Clause
.POSIX:
AS = i686-elf-as
CC = i686-elf-cc
C3C = c3c

CFLAGS = -std=c99 -Wall -Wextra -Wpedantic -Werror
C3FLAGS = --quiet --target elf-x86 --use-stdlib=no --strip-unused=no --safe=no --single-module=yes
LDFLAGS = -ffreestanding -nostdlib -T src/linker.ld -lgcc

BIN = kernel.elf
OBJS = src/boot.o src/main.o

all: $(BIN)

$(BIN): $(OBJS)
	@echo "  LD  $@"
	@$(CC) $(OBJS) $(LDFLAGS) -o $@

.c.o:
	@echo "  CC  $<"
	@$(CC) $(CFLAGS) -c $< -o $@

.c3.o:
	@echo "  C3C $<"
	@$(C3C) compile-only $(C3FLAGS) $< -o $@

.s.o:
	@echo "  AS  $<"
	@$(AS) -c $< -o $@

clean:
	rm -f $(BIN) $(OBJS)

.PHONY: all clean install uninstall
.SUFFIXES: .c .c3 .s
