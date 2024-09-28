# A Zig library for the Game Boy Advance
## Description
This is a extremly work in progress library for writting GBA homebrew in Zig.

## TODO:
- [x] make build system more modular.

## Usage
Run this ``zig fetch`` command while in your Zig project root.
```
zig fetch --save git+https://github.com/aphirr1/gba.zig
```
Example build.zig
```
const gbz = @import("gba-zig");

const optimize = b.standardOptimizeOption(.{});

const rom = gbz.addGBARom(
    b,
    game_name,
    source_file,
    optimize,
);

const gba_dep = b.dependency("gba-zig", .{});
rom.root_module.addImport("gba", gba_dep.module("gba-zig"));

const obj = gbz.installRomFile(b, rom);

gbz.addSimpleRunCommand(b, obj, emulator_command);
```

Then you can ``@import("gba")`` anywhere.
