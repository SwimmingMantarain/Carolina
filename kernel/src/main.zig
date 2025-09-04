const framebuffer = @import("./framebuffer.zig");

inline fn hlt() void {
    asm volatile ("hlt");
}

export fn _start() callconv(.C) noreturn {
    framebuffer.init();

    while (true) {
        hlt();
    }
}
