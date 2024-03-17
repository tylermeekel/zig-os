const limine = @import("limine/limine.zig");
const std = @import("std");
const video = @import("video.zig");

pub export var framebuffer_request: limine.FramebufferRequest = .{};
pub export var base_revision: limine.BaseRevision = .{ .revision = 1 };
pub export var terminal_request: limine.TerminalRequest = .{};

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

        // // Draw line from top left, 100 pixels9ik
        //     video.putPixel(.{ .x = i, .y = i }, 0xFFFF0000, framebuffer);
        // }

        // // Draw green box
        // video.putRect(.{ .x = 300, .y = 300 }, 0xFF00FF00, 50, 50, framebuffer);

        // Initial demo with 4x size white pixels
        for (0..100) |i| {
            video.putRect(.{.x = i * 2, .y = i * 2 + 1}, 0xFFFFFFFF, 2, 2, framebuffer);
        }
    }
    done();
}
