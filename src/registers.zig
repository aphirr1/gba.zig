///! All important registers
const base_timer_ptr = 0x0400_0100;
const base_timer_control_ptr = 0x0400_0102;

fn getTimerPointer(comptime timer_num: usize) *volatile u16 {
    const ptr = base_timer_ptr + (0x4 * timer_num);
    return @ptrFromInt(ptr);
}

fn getTimerControlPointer(comptime timer_num: usize) *volatile u16 {
    const ptr = base_timer_control_ptr + (0x4 * timer_num);
    return @ptrFromInt(ptr);
}

pub const timer0_control: *volatile u16 = getTimerControlPointer(0);
pub const timer0: *volatile u16 = getTimerPointer(0);

pub const timer1_control: *volatile u16 = getTimerControlPointer(1);
pub const timer1: *volatile u16 = getTimerPointer(1);

pub const timer2_control: *volatile u16 = getTimerControlPointer(2);
pub const timer2: *volatile u16 = getTimerPointer(2);

pub const timer3_control: *volatile u16 = getTimerControlPointer(3);
pub const timer3: *volatile u16 = getTimerPointer(3);

pub const interrupts_enabled: *volatile bool = @ptrFromInt(0x0400_0208);
