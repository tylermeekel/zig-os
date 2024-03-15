// Imports
const CallModifier = @import("std").builtin.CallModifier;
const console = @import("console.zig");
//@import("std").builtin.CallingConvention.

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MB1_MAGIC: u32 = 0x1BADB002;
const FLAGS: u32 = ALIGN | MEMINFO;

const MultibootHeader = extern struct {
    magic: u32 = MB1_MAGIC,
    flags: u32,
    checksum: u32,
};

export var multiboot align(4) linksection(".multiboot") = MultibootHeader{
    .flags = FLAGS,
    .checksum = @intCast(((-(@as(i64, MB1_MAGIC) + @as(i64, FLAGS))) & 0xFFFFFFFF)),
};

export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack_bytes_slice = stack_bytes[0..];

export fn _start() callconv(.C) noreturn {
    @call(CallModifier.auto, main, .{});
    while (true) {}
}

pub fn main() void {
    console.setColors(.White, .Blue);
    console.clear();
    console.putString("Hello, world");
    console.setForegroundColor(.LightRed);
    console.putChar('!');
}
