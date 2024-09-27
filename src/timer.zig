///! Namespace for everything that has to do with gba timers.
const gba = @import("self");
const reg = gba.reg;

pub const timer0: Timer = .{
    .timerPtr = @ptrCast(reg.timer0),
    .config = @ptrCast(reg.timer0_control),
};

pub const timer1: Timer = .{
    .timerPtr = @ptrCast(reg.timer1),
    .config = @ptrCast(reg.timer1_control),
};

pub const timer2: Timer = .{
    .timerPtr = @ptrCast(reg.timer2),
    .config = @ptrCast(reg.timer2_control),
};

pub const timer3: Timer = .{
    .timerPtr = @ptrCast(reg.timer3),
    .config = @ptrCast(reg.timer3_control),
};

/// gba timer, always counts down to zero then overflows back to its initial value
pub const Timer = struct {
    /// Reading the value of this ptr to gets the timers current count, but setting the value of this ptr will set the timers *next* initial count after an overflow.
    timerPtr: *volatile u16,
    config: *volatile TimerConfig,

    pub inline fn getTimerValue(self: Timer) u16 {
        return self.timerPtr.*;
    }

    ///The value passed to this function will be the timers next initial value, after an overflow.
    pub inline fn setTimerInitialValue(self: *Timer, initialValue: u16) void {
        self.timerPtr.* = initialValue;
    }

    // TODO: Think of a good naming convention for setting state using mmio
    // I dont really like `(x).setConfig(.{...});`
    // its to vague
    pub inline fn setConfig(self: *Timer, conf: TimerConfig) void {
        self.config.* = conf;
    }
};

pub const TimerConfig = packed struct(u8) {
    /// The amount on cycles it takes for the timer to count (x - 1).
    freqencyCycles: FreqencyCycleConfig,
    /// If enabled the timer will only count down everytime the timer *preceding* it overflows.
    /// Does not work on 'timer0'.
    cascadeMode: bool,
    __3bitPadding__: u3 = 0,
    interruptOnOverflow: bool,
    timerEnabled: bool,
};

pub const FreqencyCycleConfig = enum(u2) {
    @"1" = 0,
    @"64" = 1,
    @"256" = 2,
    @"1024" = 3,
};
