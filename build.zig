const std = @import("std");
const Build = std.Build;
const Step = Build.Step;

pub const linker_script = cwd() ++ "/gba.ld";
const linker_path: std.Build.LazyPath = .{ .cwd_relative = linker_script };

const root_file = "src/gba.zig";

fn cwd() []const u8 {
    return std.fs.path.dirname(@src().file) orelse "./";
}

pub fn getGBATarget(b: *std.Build) std.Build.ResolvedTarget {
    const thumb_feature_set = std.Target.arm.featureSet(&.{.thumb_mode});
    return b.standardTargetOptions(.{ .default_target = .{
        .os_tag = .freestanding,
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm7tdmi },
        .cpu_features_add = thumb_feature_set,
    } });
}

pub fn addGBARom(
    b: *Build,
    comptime game_name: []const u8,
    comptime source_file: []const u8,
    optimiztion: std.builtin.OptimizeMode,
) *Step.Compile {
    // TODO: add gdb support

    const target = getGBATarget(b);

    const exe = b.addExecutable(.{
        .name = game_name,
        .root_source_file = b.path(source_file),
        .target = target,
        .optimize = optimiztion,
    });

    b.default_step.dependOn(&exe.step);

    exe.setLinkerScript(linker_path);
    return exe;
}

pub fn addRomFile(b: *Build, exe: *Step.Compile) *Step.ObjCopy {
    const objcopy = exe.addObjCopy(.{ .format = .bin });
    objcopy.step.dependOn(&exe.step);

    const make_gba_file = b.addInstallBinFile(objcopy.getOutput(), exe.name ++ ".gba");

    make_gba_file.step.dependOn(&objcopy.step);
    b.default_step.dependOn(&make_gba_file.step);

    return objcopy;
}

pub fn addSimpleRunCommand(b: *Build, objcopy: *Step.Compile, emu_command: []const u8) void {
    const emu_cmd = b.addSystemCommand(&.{emu_command});
    if (b.args) |args| {
        emu_cmd.addArgs(args);
    }
    emu_cmd.addFileArg(objcopy.getOutput());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&emu_cmd.step);
}

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule(
        "gba-zig",
        .{
            .root_source_file = b.path(root_file),
            .optimize = optimize,
            .target = getGBATarget(b),
        },
    );
}
