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

    pub fn fromBuffer(buffer: []const u8) DXS2 {
        return DXS2{
            .glint = (buffer[0] & 0b10000000) >> 7,
            .vcslog = (buffer[0] & 0b01111000) >> 3,
            .bxvthr = buffer[0] & 0b00000111,
            .mu0 = buffer[1],
            .phi = buffer[2],
            .vrad = buffer[3],
            .bxvcsr = buffer[4],
        };
    }

    pub fn deinit(self: *DXS2) void {
        self.* = undefined;
    }
};
