const gba = @import("self");
const reg = gba.reg;

/// Needs to be set to true for interrupts to work.
pub inline fn toggleInterrupts(enable: bool) void {
    reg.interrupts_enabled.* = enable;
}

pub inline fn setInterruptControl(control: InterruptControl) void {
}

pub const InterruptControl = packed struct(u14) {
    /// Also requires display_statatistics.enable_vBlank_interrupt == true
    v_blank: bool = false,
    /// Also requires display_statatistics.enable_hBlank_interrupt == true
    h_blank: bool = false,
    /// Also requires display_statatistics.enable_vCount_interrupt == true
    v_bount: bool = false,
    /// Also requires timer(x).interruptOnOverflow to be true
    timers: InterruptTimerConfig = .{},
    /// TODO: Implement serial communication
    /// Also requires ...
    serial_communication: bool = false,
    /// TODO: Implement DMA
    /// Also requires ...
    DMA: u4 = 0,
    /// Also requires ...
    /// TODO: Implement Keypad Control
    keypad: bool = false,
    /// Interrupt raised then gamepak is removed
    gamepak_removal: bool = false,
};

pub const InterruptTimerConfig = packed struct(u4) {
    timer0: bool = false,
    timer1: bool = false,
    timer2: bool = false,
    timer3: bool = false,
};
