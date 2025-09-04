const limine = @cImport({
    @cInclude("../../limine/limine.h");
});

inline fn hlt() void {
    asm volatile("hlt" : : );
}

export fn _start() callconv(.C) noreturn {
    if (limine.terminal_request.response != null and limine.terminal_request.response.terminals_count > 0) {
        const term = limine.terminal_request.response.terminals[0];
        limine.terminal_write(term, "Hello from Carolina!", 16);
    }

    while (true) { hlt(); }
}
