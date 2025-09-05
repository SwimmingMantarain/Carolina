const font_data = @embedFile("./font.psf");

const PSF1Header = packed struct {
    magic: u16,
    mode: u8,
    charsize: u8,
};

pub const PSF1Font = struct {
    data: []const u8,
    char_height: u8,
    char_width: u8,
};

pub fn load_font() PSF1Font {
    const header = @as(*const PSF1Header, @ptrCast(@alignCast(font_data.ptr))).*;

    return PSF1Font{
        .data = font_data[4..], // Skip header
        .char_height = header.charsize,
        .char_width = 8,
    };
}
