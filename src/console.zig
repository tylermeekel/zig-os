const fmt = @import("std").fmt;
const mem = @import("std").mem;
const Writer = @import("std").io.Writer;

const VGA_WIDTH = 80;
const VGA_HEIGHT = 24;
const VGA_SIZE = VGA_WIDTH * VGA_HEIGHT;

// Enum for VGA Text Mode Colours
pub const Color = enum(u8) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

var row: usize = 0;
var column: usize = 0;

var color = vgaEntryColor(Color.LightGray, Color.Black);
var buffer = @as([*]volatile u16, @ptrFromInt(0xB8000));

fn vgaEntryColor(fg: Color, bg: Color) u8 {
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vgaEntry(uc: u8, newColor: u8) u16 {
    const c: u16 = newColor;
    return uc | (c << 8);
}

pub fn setColors(fg: Color, bg: Color) void {
    color = vgaEntryColor(fg, bg);
}

pub fn setForegroundColor(fg: Color) void {
    color = (0xF0 & color) | @intFromEnum(fg);
}

/// Set the active background color.
pub fn setBackgroundColor(bg: Color) void {
    color = (0x0F & color) | (@intFromEnum(bg) << 4);
}

pub fn clear() void {
    @memset(buffer[0..VGA_SIZE], vgaEntry(' ', color));
}

pub fn setLocation(x: u8, y: u8) void {
    row = x % VGA_WIDTH;
    column = y & VGA_HEIGHT;
}

fn putCharAt(c: u8, newColor: u8, x: usize, y: usize) void {
    const index = y * VGA_WIDTH + x;
    buffer[index] = vgaEntry(c, newColor);
}

pub fn putChar(c: u8) void {
    putCharAt(c, color, column, row);
    column += 1;
    if (column == VGA_WIDTH) {
        column = 0;
        row += 1;
        if (row == VGA_HEIGHT) {
            row = 0;
        }
    }
}

pub fn putString(data: []const u8) void {
    for (data) |c| {
        putChar(c);
    }
}

pub const writer = Writer(void, error{}, callback){ .context = {} };

fn callback(_: void, string: []const u8) error{}!usize {
    putString(string);
    return string.len;
}

pub fn printf(comptime format: []const u8, args: anytype) void {
    fmt.format(writer, format, args) catch unreachable;
}
