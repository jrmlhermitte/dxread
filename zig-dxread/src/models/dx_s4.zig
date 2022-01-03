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

    pub fn fromBuffer(buffer: [constants.DXS4_SIZE]u8) !DXS4 {
        var vret = (buffer[0] & 0b11110000) >> 4;
        var vcsret = buffer[0] & 0b00001111;
        var vcsrad = buffer[1];
        var valbta = buffer[2];
        var vcsalb = buffer[3];
        var vtmp = buffer[4];
        var vprs = buffer[5];
        var vtauic = buffer[6];
        var vtmpic = buffer[7];
        var vprsic = buffer[8];
        return DXS4{
            .vret = vret,
            .vcsret = vcsret,
            .vcsrad = vcsrad,
            .valbta = valbta,
            .vcsalb = vcsalb,
            .vtmp = vtmp,
            .vprs = vprs,
            .vtauic = vtauic,
            .vtmpic = vtmpic,
            .vprsic = vprsic,
        };
    }
};
