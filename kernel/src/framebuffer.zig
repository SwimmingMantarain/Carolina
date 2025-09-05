const limine = @import("limine");
const serial = @import("./serial.zig");

export var framebuffer_request: limine.FramebufferRequest linksection(".limine_requests") = .{};

fn get_framebuffer() *limine.Framebuffer {
    if (framebuffer_request.response) |framebuffer_response| {
        const framebuffer = framebuffer_response.getFramebuffers()[0];
        return framebuffer;
    } else {
        @panic("Framebuffer response not present");
    }
}

pub fn init() void {
    const framebuffer = get_framebuffer();

    const framebuffer_width = framebuffer.width;
    const framebuffer_height = framebuffer.height;
    const framebuffer_pitch = framebuffer.pitch;
    const framebuffer_bpp = framebuffer.bpp;

    serial.outNum(0xe9, framebuffer_width);
    serial.outb(0xe9, 'x');
    serial.outNum(0xe9, framebuffer_height);
    serial.outb(0x09, ' ');
    serial.outNum(0xe9, framebuffer_pitch);
    serial.outb(0xe9, ' ');
    serial.outNum(0xe9, framebuffer_bpp);

    for (0..framebuffer_width) |i| {
        const fb_ptr: [*]volatile u32 = @ptrCast(@alignCast(framebuffer.address));
        fb_ptr[i] = 0x00ff00;
    }
}
