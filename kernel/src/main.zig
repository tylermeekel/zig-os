const limine = @import("limine/limine.zig");
const std = @import("std");

pub export var framebuffer_request: limine.FramebufferRequest = .{};
pub export var base_revision: limine.BaseRevision = .{ .revision = 1 };

inline fn done() noreturn {
    while (true) {
        asm volatile ("hlt");
    }
}

export fn _start() callconv(.C) noreturn {
    if (!base_revision.is_supported()) {
        done();
    }

    if (framebuffer_request.response) |response| {
        if (response.framebuffer_count < 1) {
            done();
        }

        const framebuffer = response.framebuffers()[0];

        for (0..1000) |i| {
            const pixel_offset: usize = @intCast(i * framebuffer.pitch + i * 4);

            @as(*u32, @ptrCast(@alignCast(framebuffer.address + pixel_offset))).* = 0xFFFFFFFF;
        }
    }

    done();
}
