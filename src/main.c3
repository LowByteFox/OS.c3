module kernel;

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

usz terminal_row;
usz terminal_column;
char terminal_color;
ushort* terminal_buffer = (ushort*) VGA_MEMORY;

fn void terminal_initialize() 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(WHITE, BLUE);

	for (usz y = 0; y < VGA_HEIGHT; y++) {
		for (usz x = 0; x < VGA_WIDTH; x++) {
			usz index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

fn void terminal_setcolor(char color) 
{
	terminal_color = color;
}

fn void terminal_putentryat(char c, char color, usz x, usz y) 
{
	usz index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

fn void terminal_putchar(char c)
{
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;

		if (++terminal_row == VGA_HEIGHT) terminal_row = 0;
	}
}

fn void terminal_write(char* data, usz size) 
{
	for (usz i = 0; i < size; i++) {
		terminal_putchar(data[i]);
    }
}

fn void kernel_main() @export("kernel_main")
{
    terminal_initialize();
    char[] str = "Hello, kernel World from C3!";

    terminal_write(str.ptr, str.len);

    asm("hlt");
}
