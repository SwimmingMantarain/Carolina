const limine = @import("limine");
const serial = @import("./serial.zig");
const psf = @import("./psf.zig");


export var framebuffer_request: limine.FramebufferRequest linksection(".limine_requests") = .{};
var framebuffer: *limine.Framebuffer = undefined;
var fb_ptr: [*]volatile u32 = undefined;
var font: psf.PSF2Font = undefined;

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

pub fn draw_char(char: u8, x: u32, y: u32, fg: u32, bg: u32) void {
    if (char >= font.numglyph) {
        return; // Character not available in font
    }
    
    const glyph_offset = char * font.bytesperglyph;
    const glyph_data = font.data[glyph_offset..glyph_offset + font.bytesperglyph];
    
    var row: u32 = 0;
    while (row < font.char_height) : (row += 1) {
        const glyph_byte = glyph_data[row];
        var bit: u3 = 0;
        
        while (bit < 7) : (bit += 1) {
            const pixel_x = x + bit;
            const pixel_y = y + row;
            
            if ((glyph_byte >> (7 - bit)) & 1 == 1) {
                draw_pixel(pixel_x, pixel_y, fg);
            } else {
                draw_pixel(pixel_x, pixel_y, bg);
            }
        }
    }
}

const MAX_WIDTH = 1280;
const MAX_HEIGHT = 800;
const MAX_CHARS = (MAX_WIDTH / 8) * (MAX_HEIGHT / 8);
var chars_buf: [MAX_CHARS]u8 = [_]u8{0} ** MAX_CHARS;

const Console = struct {
    bg: u32 = 0x000000,
    fg: u32 = 0x00ff00,
    row: u64 = 0,
    col: u64 = 0,
    chars: [MAX_CHARS]u8,

    const Self = @This();

    pub fn render(self: Self) void {
        const chars_per_row = framebuffer.width / 8;
        const chars_per_col = framebuffer.height / 8;

        var row: u32 = 0;
        
        while (row < chars_per_col) : (row += 1) {
            var col: u32 = 0;
            while (col < chars_per_row) : (col += 1) {
                const char = self.chars[row * chars_per_row + col];

                const x = col * 8;
                const y = row * 8;

                draw_char(char, x, y, self.fg, self.bg);
            }
        }
    }

    pub fn print(self: *Self, str: []const u8) void {
        const str_len = str.len;

        var i: u32 = 0;

        const chars_per_col = framebuffer.height / 8;
        const chars_per_row = framebuffer.width / 8;

        while (i < str_len) : (i += 1) {
            if (str[i] == '\n') {
                self.row += 1;
                self.col = 0;
                continue;
            }

            if (self.col >= chars_per_row) {
                self.col = 0;
                self.row += 1;
            }

            if (self.row >= chars_per_col) {
                self.scroll();
                self.row = chars_per_col - 1;
            }

            self.chars[self.row * chars_per_row + self.col] = str[i];
            self.col += 1;
        }
    }

    fn scroll(self: *Self) void {
        const chars_per_row = framebuffer.width / 8;
        const total_chars = (framebuffer.width / 8) * (framebuffer.height / 8);

        var i: u32 = 0;
        while (i < total_chars - chars_per_row) : (i += 1) {
            self.chars[i] = self.chars[i + chars_per_row];
        }

        while (i < total_chars) : (i += 1) {
            self.chars[i] = 0;
        }
    }
};

pub fn init() Console {
    framebuffer = get_framebuffer();
    font = psf.load_font();
    fb_ptr = @ptrCast(@alignCast(framebuffer.address));

    const framebuffer_length = framebuffer.width * framebuffer.height;
    for (0..framebuffer_length) |i| {      
        fb_ptr[i] = 0x000000;
    }

    var console = Console{
        .chars = chars_buf,
    };

    @memset(&console.chars, 0);

    console.print("Hello, World from Carolina OS!\n\n");

    return console;
}
