const std = @import("std");
const constants = @import("../constants.zig");

pub const DXRecordHeader = struct {
    iwest: f32,
    ieast: f32,
    inorth: f32,
    isouth: f32,
    npix: u32,
    iout: u32,

    // iwest, ieast, inorth, isouth, npix, iout = struct.unpack(">6I", buffer)
    pub fn fromReader(reader: constants.RecordHeaderReader) !DXRecordHeader {
        var iwest10 = try reader.readIntBig(u32);
        var ieast10 = try reader.readIntBig(u32);
        var inorth10 = try reader.readIntBig(u32);
        var isouth10 = try reader.readIntBig(u32);
        var inorth = @intToFloat(f32, inorth10) / 10.0 - 90.0;
        var isouth = @intToFloat(f32, isouth10) / 10.0 - 90.0;
        var iwest = @intToFloat(f32, iwest10) / 10.0;
        var ieast = @intToFloat(f32, ieast10) / 10.0;
        var npix = try reader.readIntBig(u32);
        var iout = try reader.readIntBig(u32);
        return DXRecordHeader{
            .iwest = iwest,
            .ieast = ieast,
            .inorth = inorth,
            .isouth = isouth,
            .npix = npix,
            .iout = iout,
        };
    }
};
