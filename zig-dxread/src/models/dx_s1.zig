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

    pub fn fromBuffer(buffer: []const u8) DXS1 {
        return DXS1{
            .noday = (buffer[0] & 0b10000000) >> 7,
            .bxshor = (buffer[0] & 0b01000000) >> 6,
            .lndwtr = (buffer[0] & 0b00100000) >> 5,
            .hitopo = (buffer[0] & 0b00010000) >> 4,
            .snoice = (buffer[0] & 0b00001100) >> 2,
            .timspa = buffer[0] & 0b00000011,
            .isclog = (buffer[1] & 0b11111000) >> 3,
            .bxithr = buffer[1] & 0b00000111,
            .mue = buffer[2],
            .irad = buffer[3],
            .bxicsr = buffer[4],
        };
    }

    pub fn deinit(self: *DXS1) void {
        self.* = undefined;
    }
};
