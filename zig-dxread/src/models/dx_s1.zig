const std = @import("std");
const constants = @import("../constants.zig");

pub const DXS1 = struct {
    noday: u8,
    bxshor: u8,
    lndwtr: u8,
    hitopo: u8,
    snoice: u8,
    timspa: u8,
    isclog: u8,
    bxithr: u8,
    mue: u8,
    irad: u8,
    bxicsr: u8,

    pub fn fromBuffer(buffer: [constants.DXS1_SIZE]u8) !DXS1 {
        var noday = (buffer[0] & 0b10000000) >> 7;
        var bxshor = (buffer[0] & 0b01000000) >> 6;
        var lndwtr = (buffer[0] & 0b00100000) >> 5;
        var hitopo = (buffer[0] & 0b00010000) >> 4;
        var snoice = (buffer[0] & 0b00001100) >> 2;
        var timspa = buffer[0] & 0b00000011;
        var isclog = (buffer[1] & 0b11111000) >> 3;
        var bxithr = buffer[1] & 0b00000111;
        var mue = buffer[2];
        var irad = buffer[3];
        var bxicsr = buffer[4];
        return DXS1{
            .noday = noday,
            .bxshor = bxshor,
            .lndwtr = lndwtr,
            .hitopo = hitopo,
            .snoice = snoice,
            .timspa = timspa,
            .isclog = isclog,
            .bxithr = bxithr,
            .mue = mue,
            .irad = irad,
            .bxicsr = bxicsr,
        };
    }
};
