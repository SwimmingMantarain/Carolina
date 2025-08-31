const console = @import("./console.zig");
const mod = @import("./gdt.zig");

const GDTEntry = mod.GDTEntry;
const GDTPtr = mod.GDTPtr;
const createGDT = mod.createGDT;

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

const MultibootHeader = packed struct {
    magic: i32 = MAGIC,
    flags: i32,
    checksum: i32,
    padding: u32 = 0,
};

export var multiboot: MultibootHeader align(4) linksection(".multiboot") = .{
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

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
