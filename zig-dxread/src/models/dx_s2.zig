const std = @import("zig");
const constants = @import("../constants.zig");

pub const DXS2 = struct {
    glint: u8,
    vcslog: u8,
    bxvthr: u8,
    mu0: u8,
    phi: u8,
    vrad: u8,
    bxvcsr: u8,

    pub fn fromBuffer(buffer: [constants.DXS2_SIZE]u8) !DXS2 {
        var glint = (buffer[0] & 0b10000000) >> 7;
        var vcslog = (buffer[0] & 0b01111000) >> 3;
        var bxvthr = buffer[0] & 0b00000111;
        var mu0 = buffer[1];
        var phi = buffer[2];
        var vrad = buffer[3];
        var bxvcsr = buffer[4];
        return DXS2{
            .glint = glint,
            .vcslog = vcslog,
            .bxvthr = bxvthr,
            .mu0 = mu0,
            .phi = phi,
            .vrad = vrad,
            .bxvcsr = bxvcsr,
        };
    }
};
