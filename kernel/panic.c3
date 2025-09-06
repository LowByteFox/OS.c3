/* SPDX-License-Identifier: BSD-2-Clause */
module kernel;

import kernel::arch::tty;

fn void panic(String message)
{
    tty::putchar('\n');
    char color = tty::vga_entry_color(LIGHT_RED, BLACK);

    tty::write_color("kernel panic: ", 14, color);
    tty::write_color(message.ptr, message.len, color);

    asm("hlt");
}
