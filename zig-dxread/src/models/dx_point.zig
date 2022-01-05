const std = @import("std");
const constants = @import("../constants.zig");

pub const DXPoint = struct {
    lat: f32,
    lon: f32,
    x: u32,
    y: u32,

    pub fn fromBuffer(buffer: []const u8) !DXPoint {
        const lon10: u16 = std.mem.readIntBig(u16, buffer[0..2]);
        const lat10: u16 = std.mem.readIntBig(u16, buffer[2..4]);
        const x: u16 = std.mem.readIntBig(u16, buffer[4..6]);
        const y: u16 = std.mem.readIntBig(u16, buffer[6..8]);

        const lon: f32 = @intToFloat(f32, lon10) / 10.0;
        const lat: f32 = @intToFloat(f32, lat10) / 10.0 - 90.0;
        return DXPoint{
            .lon = lon,
            .lat = lat,
            .x = x,
            .y = y,
        };
    }

    pub fn deinit(self: *DXPoint) void {
        self.* = undefined;
    }
};
