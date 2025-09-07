const framebuffer = @import("./framebuffer.zig");

inline fn hlt() void {
    asm volatile ("hlt");
}

export fn _start() callconv(.C) noreturn {
    var console = framebuffer.init();

    while (true) {
        console.render();
        hlt();
    }
}
