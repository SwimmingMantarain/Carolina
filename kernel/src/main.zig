const framebuffer = @import("./framebuffer.zig");

inline fn hlt() void {
    asm volatile ("hlt");
}

export fn _start() callconv(.C) noreturn {
    framebuffer.init();

    framebuffer.draw_line(100, 100, 200, 100, 0x00ff00);
    framebuffer.draw_line(100, 100, 100, 200, 0x00ff00);
    framebuffer.draw_line(0, 0, 200, 200, 0x00ff00);

    framebuffer.draw_rect(300, 300, 450, 450, 0x00ff00, true);
    framebuffer.draw_rect(500, 300, 650, 450, 0x0000ff, true);

    framebuffer.draw_char('A', 1000, 600, 0xff0000, 0x0f0f0f);

    framebuffer.draw_str("F*ck Yeah!", 1000, 700, 0x000000, 0xffffff);

    while (true) {
        hlt();
    }
}
