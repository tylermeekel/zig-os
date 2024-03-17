const limine = @import("limine/limine.zig");
const std = @import("std");

pub const Coord = struct {
    x: usize,
    y: usize,
};

// Put a pixel at a certain coordinate
pub fn putPixel(where: Coord, color: u32, framebuffer: *limine.Framebuffer) void {
    // Calculate pixel offset. Pitch = # of bytes to skip to get to next line
    const pixel_offset: usize = @intCast(where.y * framebuffer.pitch + where.x * 4);

    putPixelAtOffset(pixel_offset, color, framebuffer);
}

fn putPixelAtOffset(offset: usize, color: u32, framebuffer: *limine.Framebuffer) void {
    @as(*u32, @ptrCast(@alignCast(framebuffer.address + offset))).* = color;
}

// A slightly optimized method of drawing a rectangle
pub fn putRect(topLeft: Coord, color: u32, height: usize, width: usize, framebuffer: *limine.Framebuffer) void {
    var pixel_offset: usize = @intCast(topLeft.y * framebuffer.pitch + topLeft.x * 4);

    for (0..height) |_| {
        for (0..width) |x_offset| {
            putPixelAtOffset(pixel_offset + x_offset * 4, color, framebuffer);
        }
        pixel_offset += framebuffer.pitch;
    }
}
