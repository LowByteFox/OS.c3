/* SPDX-License-Identifier: BSD-2-Clause */
module kernel::libc;

import kernel;

fn void abort() @export("abort")
{
    kernel::panic("Invoked from libgcc!");
}
