const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    var query = std.Target.Query{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
    };

    const Features = std.Target.x86.Feature;
    query.cpu_features_sub.addFeature(@intFromEnum(Features.mmx));
    query.cpu_features_sub.addFeature(@intFromEnum(Features.sse));
    query.cpu_features_sub.addFeature(@intFromEnum(Features.sse2));
    query.cpu_features_sub.addFeature(@intFromEnum(Features.avx));
    query.cpu_features_sub.addFeature(@intFromEnum(Features.avx2));
    query.cpu_features_add.addFeature(@intFromEnum(Features.soft_float));

    const target = b.resolveTargetQuery(query);

    const kernel = b.addExecutable(.{
        .name = "kernel",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = .ReleaseFast,
        .code_model = .kernel,
    });

    kernel.setLinkerScript(.{ .path = "src/linker.ld" });
    kernel.pie = true;

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(kernel);
}
