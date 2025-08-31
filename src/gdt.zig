pub const GDTEntry = packed struct {
    limit_low: u16,
    base_low: u16,
    base_middle: u8,
    access: u8,
    granularity: u8,
    base_high: u8
};

pub const GDTPtr = packed struct {
    limit: u16,
    base: u32,
};

fn createGDTEntry(base: u32, limit: u32, access: u8, granularity: u8) GDTEntry {
    const entry = GDTEntry{
        .limit_low = @as(u16, @intCast(limit & 0xFFFF)),
        .base_low = @as(u16, @intCast(base & 0xFFFF)),
        .base_middle = @as(u8, @intCast((base >> 16) & 0xFF)),
        .access = access,
        .granularity = granularity | @as(u8, @intCast((limit >> 16) & 0xF)),
        .base_high = @as(u8, @intCast((base >> 24) & 0xFF)),
    };

    return entry;
}

pub fn createGDT() [3]GDTEntry {
    const zero = createGDTEntry(0, 0, 0, 0);
    const kernel_code = createGDTEntry(0, 0xFFFFF, 0x9A, 0xC0);
    const kernel_data = createGDTEntry(0, 0xFFFFF, 0x92, 0xC0);

    return [3]GDTEntry{zero, kernel_code, kernel_data};
}
