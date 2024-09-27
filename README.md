# A Zig library for the Game Boy Advance
## Description
This is a extremly work in progress library for writting GBA homebrew in Zig.

## TODO:
- [ ] make build system more modular.

## Usage
Run this ``zig fetch`` command while in your Zig project root.
```
zig fetch --save git+https://github.com/aphirr1/gba.zig
```
Put this in your build.zig
```
const gbz = @import("gba-zig");

_ = gbz.addGBARom(
    b,
    game_name,
    source_file,
    optimize,
    emulator_command,
);
```

Then you can ``@import("gba")`` anywhere.
