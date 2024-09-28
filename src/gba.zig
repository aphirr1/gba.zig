pub const timer = @import("timer.zig");
pub const reg = @import("registers.zig");
const std = @import("std");
const root = @import("root");

pub const keypad: *volatile Keypad = @ptrFromInt(0x400_0130);

/// Every color can be from 0-31.
pub const Color = packed struct(u15) {
    red: u5,
    green: u5,
    blue: u5,
};

pub const Keypad = packed struct(u10) {
    keyA: KeyState,
    keyB: KeyState,
    keySelect: KeyState,
    keyStart: KeyState,
    keyRight: KeyState,
    keyLeft: KeyState,
    keyUp: KeyState,
    keyDown: KeyState,
    keyR: KeyState,
    keyL: KeyState,
};

const KeyState = enum(u1) {
    up = 1,
    down = 0,
};

export fn gMain() void {
    if (@hasDecl(root, "main")) {
        root.main();
    } else {
        @compileError("root file has no member named 'main'");
    }
}

export fn _start() linksection(".text._start") callconv(.Naked) noreturn {
    asm volatile (
        \\.arm
        \\.cpu arm7tdmi
        //
        \\b end_of_header 
        \\.space 0xE0
        \\end_of_header:
        \\ldr r12, =gMain
        \\bx r12    
    );
    while (true) {}
}
