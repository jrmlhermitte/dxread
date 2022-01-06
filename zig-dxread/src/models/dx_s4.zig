const std = @import("zig");
const constants = @import("../constants.zig");

pub const DXS4 = struct {
    vret: u8,
    vcsret: u8,
    vcsrad: u8,
    valbta: u8,
    vcsalb: u8,
    vtmp: u8,
    vprs: u8,
    vtauic: u8,
    vtmpic: u8,
    vprsic: u8,

    pub fn fromBuffer(buffer: []const u8) DXS4 {
        return DXS4{
            .vret = (buffer[0] & 0b11110000) >> 4,
            .vcsret = buffer[0] & 0b00001111,
            .vcsrad = buffer[1],
            .valbta = buffer[2],
            .vcsalb = buffer[3],
            .vtmp = buffer[4],
            .vprs = buffer[5],
            .vtauic = buffer[6],
            .vtmpic = buffer[7],
            .vprsic = buffer[8],
        };
    }

    pub fn deinit(self: *DXS4) void {
        self.* = undefined;
    }
};
