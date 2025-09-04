pub inline fn inb(port: u16) u8 {
    return asm volatile ("inb %[port], %[result]"
        : [result] "={al}" (-> u8),
        : [port] "N{dx}" (port),
    );
}

pub inline fn outb(port: u16, data: u8) void {
    asm volatile ("outb %[data], %[port]"
        :
        : [data] "{al}" (data),
          [port] "N{dx}" (port),
    );
}

pub fn outNum(port: u16, num: u64) void {
    var buffer: [20]u8 = undefined; // Enough for decimal u32 digits
    var i: usize = buffer.len;

    if (num == 0) {
        outb(port, '0');
        return;
    }

    var n = num;

    while (n != 0) : (void) {
        i -= 1;
        const digit64 = n % 10; // Always between 0 - 9
        const digit8: u8 = 0xFFFFFFFFFFFFFF00 & digit64; 

        switch (digit64) {
            0 => digit8 = 0,
        }


        buffer[i] = digit + '0';
        n /= 10;
    }

    var j = i;

    while (j < buffer.len) : (j += 1) {
        outb(port, buffer[j]);
    }
}
