inline fn inb(port: u16) u8 {
    return asm volatile ("inb %[port], %[result]"
        : [result] "={al}" (-> u8),
        : [port] "N{dx}" (port),
    );
}

inline fn outb(port: u16, data: u8) void {
    asm volatile ("outb %[data], %[port]"
        :
        : [data] "{al}" (data),
          [port] "N{dx}" (port),
    );
}

inline fn hlt() void {
    asm volatile("hlt" : : );
}

export fn _start() callconv(.C) noreturn {
    outb(0xe9, 'H');
    outb(0xe9, 'e');
    outb(0xe9, 'l');
    outb(0xe9, 'l');
    outb(0xe9, 'o');
    outb(0xe9, ' ');
    outb(0xe9, 'f');
    outb(0xe9, 'r');
    outb(0xe9, 'o');
    outb(0xe9, 'm');
    outb(0xe9, ' ');
    outb(0xe9, 'C');
    outb(0xe9, 'a');
    outb(0xe9, 'r');
    outb(0xe9, 'o');
    outb(0xe9, 'l');
    outb(0xe9, 'i');
    outb(0xe9, 'n');
    outb(0xe9, 'a');
    outb(0xe9, '!');

    while (true) {}
}
