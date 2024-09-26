const std = @import("std");
const Build = std.Build;
const Step = Build.Step;

const linker_script = cwd() ++ "/gba.ld";
const linker_path: std.Build.LazyPath = .{ .cwd_relative = linker_script };

const root_file = cwd() ++ "/src/gba.zig";
const root_path: Build.LazyPath = .{ .cwd_relative = root_file };

const entry_file = cwd() ++ "/entry/entry.zig";
const entry_path: Build.LazyPath = .{ .cwd_relative = entry_file };

fn cwd() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
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

fn getGBALib(b: *Build, optimiztion: std.builtin.OptimizeMode, target: std.Build.ResolvedTarget) *Step.Compile {
    const lib = b.addStaticLibrary(.{
        .name = "gba.zig",
        .root_source_file = root_path,
        .target = target,
        .optimize = optimiztion,
    });

    lib.setLinkerScript(linker_path);

    lib.root_module.addImport("self", &lib.root_module);

    return lib;
}

fn makeGBAEntry(b: *Build, optimiztion: std.builtin.OptimizeMode, target: std.Build.ResolvedTarget, exe: *Step.Compile) *Step.Compile {
    const entry = b.addExecutable(.{
        .name = "ENTRY",
        .root_source_file = entry_path,
        .target = target,
        .optimize = optimiztion,
    });

    entry.setLinkerScript(linker_path);

    entry.root_module.addImport("user_root", &exe.root_module);

    return entry;
}

// horrable function
pub fn addGBARom(
    b: *Build,
    comptime game_name: []const u8,
    comptime source_file: []const u8,
    optimiztion: std.builtin.OptimizeMode,
    emulator_command: ?[]const u8,
) *Step.Compile {
    // TODO: add gdb support

    const target = getGBATarget(b);

    const exe = b.addStaticLibrary(.{
        .name = game_name,
        .root_source_file = b.path(source_file),
        .target = target,
        .optimize = optimiztion,
    });

    const lib = getGBALib(b, optimiztion, target);
    const entry = makeGBAEntry(b, optimiztion, target, exe);

    //exe.linkLibrary(lib);
    exe.root_module.addImport("gba", &lib.root_module);

    b.default_step.dependOn(&entry.step);

    const objcopy = entry.addObjCopy(.{ .format = .bin });
    entry.step.dependOn(&exe.step);

    const make_gba_file = b.addInstallBinFile(objcopy.getOutput(), game_name ++ ".gba");
    make_gba_file.step.dependOn(&objcopy.step);

    if (emulator_command) |command| {
        const emu_cmd = b.addSystemCommand(&.{command});

        if (b.args) |args| {
            emu_cmd.addArgs(args);
        }
        emu_cmd.addFileArg(objcopy.getOutput());

        const run_step = b.step("run", "Run the app");
        b.default_step.dependOn(&make_gba_file.step);
        run_step.dependOn(&emu_cmd.step);
    }

    exe.setLinkerScript(linker_path);
    return exe;
}

pub fn build(b: *std.Build) void {
    _ = b;
}
