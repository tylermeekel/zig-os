//! This source file contains functions that help load data for
//! a BDF font file, in order to prepare it for rendering. As of
//! right now, this is the only font type that FLOS supports.

const std = @import("std");

const BDFGlyph = struct {

};

const BDFGlyphMap = std.AutoHashMap(u8, BDFGlyph);

pub fn LoadBDFGlyphs(_: []const u8) BDFGlyphMap {
}
