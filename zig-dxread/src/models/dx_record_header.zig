const std = @import("std");
const constants = @import("../constants.zig");

pub const DXRecordHeader = struct {
    iwest: f32,
    ieast: f32,
    inorth: f32,
    isouth: f32,
    npix: u32,
    iout: u32,

    pub fn fromBuffer(buffer: *[constants.RECORD_HEADER_SIZE]u8) !DXRecordHeader {
        const iwest10 = std.mem.readIntBig(u32, buffer[0..4]);
        const ieast10 = std.mem.readIntBig(u32, buffer[4 .. 4 * 2]);
        const inorth10 = std.mem.readIntBig(u32, buffer[4 * 2 .. 4 * 3]);
        const isouth10 = std.mem.readIntBig(u32, buffer[4 * 3 .. 4 * 4]);
        const npix = std.mem.readIntBig(u32, buffer[4 * 4 .. 4 * 5]);
        const iout = std.mem.readIntBig(u32, buffer[4 * 5 .. 4 * 6]);
        const inorth = @intToFloat(f32, inorth10) / 10.0 - 90.0;
        const isouth = @intToFloat(f32, isouth10) / 10.0 - 90.0;
        const iwest = @intToFloat(f32, iwest10) / 10.0;
        const ieast = @intToFloat(f32, ieast10) / 10.0;
        return DXRecordHeader{
            .iwest = iwest,
            .ieast = ieast,
            .inorth = inorth,
            .isouth = isouth,
            .npix = npix,
            .iout = iout,
        };
    }

    pub fn deinit(self: *DXRecordHeader) void {
        self.* = undefined;
    }
};
