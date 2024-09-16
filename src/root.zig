pub const timers = @import("timers.zig");

pub const keypad: *volatile Keypad = @ptrFromInt(0x400_0130);

/// Works like rgb but very color can only be a value from 0 to 31.
pub const Color = packed struct(u16) {
    transparent: bool = false,
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
