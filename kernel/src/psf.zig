const std = @import("std");

const font_data = @embedFile("font.psf");

const PSF2Header = packed struct {
    magic: u32,        // 0x864AB572
    version: u32,      // 0 for PSF2
    headersize: u32,   // Size of PSF2Header (32)
    flags: u32,        // 0 if no Unicode table
    numglyph: u32,     // Number of glyphs
    bytesperglyph: u32, // Number of bytes per glyph
    height: u32,       // Height in pixels
    width: u32,        // Width in pixels
};

pub const PSF2Font = struct {
    data: []const u8,
    char_height: u32,
    char_width: u32,
    numglyph: u32,
    bytesperglyph: u32,
};

pub fn load_font() PSF2Font {
    const header = @as(*const PSF2Header, @ptrCast(@alignCast(font_data.ptr)));
    
    if (header.magic != 0x864AB572) {
        @panic("Invalid PSF2 magic number");
    }

    const glyph_data = font_data[header.headersize..];
    
    return PSF2Font{
        .data = glyph_data,
        .char_height = header.height,
        .char_width = header.width,
        .numglyph = header.numglyph,
        .bytesperglyph = header.bytesperglyph,
    };
}
