const std = @import("std");
const user_root = @import("user_root");

export fn gMain() void {
    if (@hasDecl(user_root, "main")) {
        user_root.main();
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
