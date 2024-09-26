const gba = @import("self");
const reg = gba.reg;

/// Needs to be set to true for interrupts to work.
pub fn toggleInterrupts(enable: bool) void {
    reg.interrupts_enabled.* = enable;
}

pub const InterruptConfig = packed struct(u14) {
    /// Also requires display_statatistics.enable_vBlank_interrupt == true
    vBlank: bool = false,
    /// Also requires display_statatistics.enable_hBlank_interrupt == true
    hBlank: bool = false,
    /// Also requires display_statatistics.enable_vCount_interrupt == true
    vCount: bool = false,
    /// Also requires timer(x).interruptOnOverflow to be true
    timers: InterruptTimerConfig = .{},
    /// TODO: Implement serial communication
    /// Also requires ...
    serial_communication: bool = false,
    /// TODO: Implement DMA
    /// Also requires ...
    DMA: u4 = false,
    /// Also requires ...
    /// TODO: Implement Keypad Control
    keypad: bool = false,
    /// Interrupt raised then gamepak is removed
    gamepak_removal: bool = false,
};

pub const InterruptTimerConfig = packed struct(u4) {
    enable_timer0_interrupt: bool = false,
    enable_timer1_interrupt: bool = false,
    enable_timer2_interrupt: bool = false,
    enable_timer3_interrupt: bool = false,
};
