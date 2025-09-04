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

    serial.outNum(0x09, framebuffer_width);
    serial.outNum(0x09, framebuffer_height);

    for (0..1000) |i| {
        const fb_ptr: [*]volatile u32 = @ptrCast(@alignCast(framebuffer.address));
        fb_ptr[i * (framebuffer.pitch / 4) + i] = 0xffffff;
    }
}
