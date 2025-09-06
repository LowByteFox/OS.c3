/* SPDX-License-Identifier: BSD-2-Clause */
module kernel;

import kernel::arch::tty;

fn void kernel_main() @export("kernel_main")
{
    tty::initialize();
    char[] str = "Hello, kernel World from C3!";

    tty::write(str.ptr, str.len);

    panic("Rust");
}
