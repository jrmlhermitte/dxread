const std = @import("std");
const constants = @import("../constants.zig");

pub const DXPoint = struct {
    lat: f32,
    lon: f32,
    x: u32,
    y: u32,

    pub fn fromReader(reader: constants.RecordReader) !DXPoint {
        var lon10: u16 = try reader.readIntBig(u16);
        var lat10: u16 = try reader.readIntBig(u16);
        var x: u16 = try reader.readIntBig(u16);
        var y: u16 = try reader.readIntBig(u16);

        var lon: f32 = @intToFloat(f32, lon10) / 10.0;
        var lat: f32 = @intToFloat(f32, lat10) / 10.0 - 90.0;
        return DXPoint{
            .lon = lon,
            .lat = lat,
            .x = x,
            .y = y,
        };
    }
};
