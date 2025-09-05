const framebuffer = @import("./framebuffer.zig");

inline fn hlt() void {
    asm volatile ("hlt");
}

export fn _start() callconv(.C) noreturn {
    framebuffer.init();

    framebuffer.draw_line(100, 100, 100, 200, 0x00ff00);
    framebuffer.draw_line(100, 100, 200, 99, 0x00ff00);


    //framebuffer.draw_rect(200, 250, 500, 600, 0xff00ff);

    while (true) {
        hlt();
    }
}
