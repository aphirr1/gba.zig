///! Namespace for everything that has to do with gba timers.
pub const timer0: Timer = .{
    .timerPtr = @ptrFromInt(0x0400_0100),
    .config = @ptrFromInt(0x0400_0102),
};

pub const timer1: Timer = .{
    .timerPtr = @ptrFromInt(0x0800_0100),
    .config = @ptrFromInt(0x0800_0102),
};

pub const timer2: Timer = .{
    .timerPtr = @ptrFromInt(0x0c00_0100),
    .config = @ptrFromInt(0x0c00_0102),
};

pub const timer3: Timer = .{
    .timerPtr = @ptrFromInt(0x0010_0100),
    .config = @ptrFromInt(0x0010_0102),
};

/// gba timer, always counts down to zero then overflows back to its initial value
pub const Timer = struct {
    /// Read the value of this ptr to get the timers current value, but the value you set to this ptr with be the timers *next* initial value, after an overflow.
    timerPtr: *volatile u16,
    config: *volatile TimerConfig,

    pub fn getTimerValue(self: Timer) u16 {
        return self.timerPtr.*;
    }

    ///The value passed to thus function will be the timers next initial value, after an overflow.
    pub fn setTimerInitialValue(self: *Timer, initialValue: u16) void {
        self.timerPtr.* = initialValue;
    }

    pub fn setConfig(self: *Timer, conf: TimerConfig) void {
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
