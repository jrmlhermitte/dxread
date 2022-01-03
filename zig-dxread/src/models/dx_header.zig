const std = @import("std");
const fs = std.fs;
const constants = @import("../constants.zig");

/// DX Header
pub const DXHeader = struct {
    /// Year
    year: u32,
    /// Month
    month: u32,
    /// day
    day: u32,
    utc: u32,
    satid: u32,
    sattyp: u32,
    nchans: u32,
    nghtimg: u32,

    fn trimAndParseInt(buffer: []u8) !u32 {
        return try std.fmt.parseInt(u32, std.mem.trimLeft(u8, buffer, " "), 10);
    }

    fn readNextAndParseInt(reader: constants.RecordHeaderReader, comptime numBytes: u64) !u32 {
        var buffer = (try reader.readBytesNoEof(numBytes))[0..];
        var res = try trimAndParseInt(buffer);
        return res;
    }

    pub fn fromReader(reader: constants.RecordHeaderReader) !DXHeader {
        var year: u32 = try readNextAndParseInt(reader, 10);
        var month: u32 = try readNextAndParseInt(reader, 10);
        var day: u32 = try readNextAndParseInt(reader, 10);
        var utc: u32 = try readNextAndParseInt(reader, 10);
        var satid: u32 = try readNextAndParseInt(reader, 10);
        var sattyp: u32 = try readNextAndParseInt(reader, 10);
        var nchans: u32 = try readNextAndParseInt(reader, 10);
        var nghtimg: u32 = try readNextAndParseInt(reader, 10);
        return DXHeader{
            .year = year,
            .month = month,
            .day = day,
            .utc = utc,
            .satid = satid,
            .sattyp = sattyp,
            .nchans = nchans,
            .nghtimg = nghtimg,
        };
    }
};
