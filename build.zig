const std = @import("std");

pub fn build(b: *std.Build) void {
    const thumb_feature_set = std.Target.arm.featureSet(&.{.thumb_mode});

    var target = b.standardTargetOptions(.{ .default_target = .{
        .os_tag = .freestanding,
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm7tdmi },
    } });

    target.query.cpu_features_add.addFeatureSet(thumb_feature_set);
    target.result.cpu.features.addFeatureSet(thumb_feature_set);

    const optimize = b.standardOptimizeOption(.{});

    const sourceFile = "src/root.zig";

    _ = b.addModule("gba-std", .{
        .root_source_file = .{ .cwd_relative = sourceFile },
    });

    const lib = b.addStaticLibrary(.{
        .name = "gba-std",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const docs_step = b.step("docs", "Emit docs");

    const docs_install = b.addInstallDirectory(.{
        .install_dir = .prefix,
        .install_subdir = "docs",
        .source_dir = lib.getEmittedDocs(),
    });

    docs_step.dependOn(&docs_install.step);
    b.default_step.dependOn(docs_step);
}
