const limine = @import("limine");
const serial = @import("./serial.zig");

export var framebuffer_request: limine.FramebufferRequest linksection(".limine_requests") = .{};
var framebuffer: *limine.Framebuffer = undefined;
var fb_ptr: [*]volatile u32 = undefined;

fn get_framebuffer() *limine.Framebuffer {
    if (framebuffer_request.response) |framebuffer_response| {
        return framebuffer_response.getFramebuffers()[0];
    } else {
        @panic("Framebuffer response not present");
    }
}

pub fn draw_pixel(x: u32, y: u32, color: u32) void {
    if (x > framebuffer.width) {
        return;
    } else if (y > framebuffer.height) {
        return;
    } else {
        fb_ptr[x + y * framebuffer.width] = color;
    }
}

pub fn draw_line(x1: u32, y1: u32, x2: u32, y2: u32, color: u32) void {
    const dx = @as(i32, @intCast(@abs(x2 - x1)));
    const dy = -@as(i32, @intCast(@abs(y2 - y1)));

    var sx: i32 = 0;
    var sy: i32 = 0;

    if (x1 < x2) {
        sx = 1;
    } else {
        sx = -1;
    }

    if (y1 < y2) {
        sy = 1;
    } else {
        sy = -1;
    }

    var err = dx + dy;
    var xn = @as(i32, @intCast(x1));
    var yn = @as(i32, @intCast(y1));

    while (xn != x2 or yn != y2) {
        draw_pixel(@as(u32, @intCast(xn)), @as(u32, @intCast(yn)), color);

        const err2 = 2 * err;

        if (err2 >= dy) {
            err += dy;
            xn += sx;
        }

        if (err2 <= dx) {
            err += dx;
            yn += sy;
        }
    }
}

pub fn draw_rect(x1: u32, y1: u32, x2: u32, y2: u32, color: u32, fill: bool) void {
    if (fill) {
        var yn = y1;

        while (yn <= y2) : (yn += 1) {
            var xn = x1;
            while (xn <= x2) : (xn += 1) {
                draw_pixel(xn, yn, color);
            }
        }
    } else {
        draw_line(x1, y1, x1, y2, color); // left
        draw_line(x1, y1, x2, y1, color); // top
        draw_line(x2, y1, x2, y2, color); // right
        draw_line(x1, y2, x2, y2, color); // bottom
    }

}

pub fn init() void {
    framebuffer = get_framebuffer();
    fb_ptr = @ptrCast(@alignCast(framebuffer.address));

    const framebuffer_length = framebuffer.width * framebuffer.height;

    serial.outNum(0xe9, framebuffer.width);
    serial.outb(0xe9, 'x');
    serial.outNum(0xe9, framebuffer.height);

    for (0..framebuffer_length) |i| {      
        fb_ptr[i] = 0x000000;
    }
}
