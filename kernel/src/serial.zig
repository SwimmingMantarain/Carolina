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
pub fn outbnl(port: u16) void {
    outb(port, 0x0A);
}

pub fn outStr(port: u16, str: []const u8) void {
    const str_len = str.len;

    var i: u32 = 0;

    while (i < str_len) : (i += 1) {
        outb(port, str[i]);
    }
}

pub fn outNumArr(port: u16, num_arr: []const u8) void {
    const arr_len = num_arr.len;

    var i: u32 = 0;

    while (i < arr_len) : (i += 1) {
        outNum(port, num_arr[i]);
        outbnl(port);
    }
}

pub fn outNum(port: u16, num: u64) void {
    var buffer: [20]u8 = undefined; // Enough for decimal u32 digits
    var i: usize = buffer.len;

    if (num == 0) {
        outb(port, '0');
        return;
    }

    var n = num;

    while (n != 0) {
        i -= 1;
        const digit64 = n % 10; // Always between 0 - 9
        var digit8: u8 = 0;

        switch (digit64) {
            0 => digit8 = '0',
            1 => digit8 = '1',
            2 => digit8 = '2',
            3 => digit8 = '3',
            4 => digit8 = '4',
            5 => digit8 = '5',
            6 => digit8 = '6',
            7 => digit8 = '7',
            8 => digit8 = '8',
            9 => digit8 = '9',
            else => digit8 = '0',
        }


        buffer[i] = digit8;
        n /= 10;
    }

    var j = i;

    while (j < buffer.len) : (j += 1) {
        outb(port, buffer[j]);
    }
}
