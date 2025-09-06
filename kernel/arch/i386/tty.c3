/* SPDX-License-Identifier: BSD-2-Clause */
module kernel::arch::tty;

enum VgaColor : const inline int {
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    LIGHT_GREY,
    DARK_GREY,
    LIGHT_BLUE,
    LIGHT_GREEN,
    LIGHT_CYAN,
    LIGHT_RED,
    LIGHT_MAGENTA,
    LIGHT_BROWN,
    WHITE
}

fn char vga_entry_color(VgaColor fg, VgaColor bg) @inline
{
    return (char) (fg | bg << 4);
}

fn ushort vga_entry(char uc, char color)
{
    return (ushort) uc | (ushort) color << 8;
}

const VGA_WIDTH = 80;
const VGA_HEIGHT = 25;
const VGA_MEMORY = 0xB8000;

usz terminal_row @local;
usz terminal_column @local;
char terminal_color @local;
ushort* terminal_buffer @local = (ushort*) VGA_MEMORY;

fn void initialize() 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(WHITE, BLACK);

	for (usz y = 0; y < VGA_HEIGHT; y++) {
		for (usz x = 0; x < VGA_WIDTH; x++) {
			usz index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

fn void setcolor(char color) 
{
	terminal_color = color;
}

fn void putentryat(char c, char color, usz x, usz y) @local
{
	usz index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

fn void putchar(char c) => putchar_color(c, terminal_color);

fn void putchar_color(char c, char color)
{
    switch (c) {
    case '\n':
        terminal_column = 0;
        terminal_row++;
    default:
	    putentryat(c, color, terminal_column, terminal_row);
        terminal_column++;
    }

	if (terminal_column == VGA_WIDTH) {
		terminal_column = 0;

		if (++terminal_row == VGA_HEIGHT) terminal_row = 0;
	}
}

fn void write(char *data, usz size) => write_color(data, size, terminal_color);

fn void write_color(char *data, usz size, char color)
{
	for (usz i = 0; i < size; i++) {
		putchar_color(data[i], color);
    }
}
