const console = @import("./console.zig");
const mod = @import("./gdt.zig");

const GDTEntry = mod.GDTEntry;
const GDTPtr = mod.GDTPtr;
const createGDT = mod.createGDT;

const MB2_MAGIC  = 0xE85250D6;
const ARCH_I386  = 0; 
const MB2_END    = 0;
const TAG_END_SZ = 8;

const MultibootHeader = packed struct {
    magic: u32 = MAGIC,
    architecture: u32 = ARCH_I386,
    header_length: u32,
    checksum: u32,
    // Optional Tags
    end_type: u16 = MB2_END,
    end_flags: u16 = 0,
    end_size: u32 = TAG_END_SZ,
};

fn makeHeader() MB2Header {
    var h = MB2Header{ .header_length = @sizeOf(MB2Header), .checksum = 0 };
    const sum: u64 = @as(u64, h.magic) + h.architecture + h.header_length;
    h.checksum = @as(u32, 0) - @as(u32, @intCast(sum));
    return h;
}

export var multiboot2_header: MB2Header align(8) linksection(".multiboot2") = makeHeader();

var stack_bytes: [16*1024]u8 align(16) linksection(".bss") = undefined;
var gdt: [3]GDTEntry align(8) linksection(".bss") = undefined;

export fn _start() callconv(.Naked) noreturn {
    asm volatile (
        \\ movl %[stack_top], %%esp
        \\ movl %%esp, %%ebp
        \\ call %[kmain32:P]
        :
        : [stack_top] "i" (@as([*]align(16) u8, @ptrCast(&stack_bytes)) + @sizeOf(@TypeOf(stack_bytes))),
          [kmain32] "X" (&kmain32)
        :
    );
}

fn kmain32() callconv(.C) void {
    console.initialise();
    gdt = createGDT();

    const gdt_ptr = GDTPtr{
        .limit = @sizeOf(@TypeOf(gdt)) - 1,
        .base = @intFromPtr(&gdt),
    };

    asm volatile (
        \\ lgdt %[gdt_ptr]
        \\ ljmp $0x08, $1f
        \\ 1:
        \\ movw $0x10, %ax
        \\ movw %ax, %ds
        \\ movw %ax, %es
        \\ movw %ax, %fs
        \\ movw %ax, %gs
        \\ movw %ax, %ss
        :
        : [gdt_ptr] "m"(&gdt_ptr)
        :
    );

    console.puts("GDT [OK]");

    while (true) {
        asm volatile (
            \\ hlt
            :
            :
            :
        );
    }
}
