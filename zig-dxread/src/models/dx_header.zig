const std = @import("std");
const fs = std.fs;
const constants = @import("../constants.zig");

pub const DXHeader = struct {
    year: u32,
    month: u32,
    day: u32,
    utc: u32,
    satid: u32,
    sattyp: u32,
    nchans: u32,
    nghtimg: u32,

    fn trimAndParseInt(buffer: *const [10]u8) !u32 {
        return try std.fmt.parseInt(u32, std.mem.trimLeft(u8, buffer, " "), 10);
    }

    pub fn fromBuffer(buffer: [constants.RECORD_SIZE]u8) !DXHeader {
        const year: u32 = try trimAndParseInt(buffer[0..10]);
        const month: u32 = try trimAndParseInt(buffer[10 .. 10 * 2]);
        const day: u32 = try trimAndParseInt(buffer[10 * 2 .. 10 * 3]);
        const utc: u32 = try trimAndParseInt(buffer[10 * 3 .. 10 * 4]);
        const satid: u32 = try trimAndParseInt(buffer[10 * 4 .. 10 * 5]);
        const sattyp: u32 = try trimAndParseInt(buffer[10 * 5 .. 10 * 6]);
        const nchans: u32 = try trimAndParseInt(buffer[10 * 6 .. 10 * 7]);
        const nghtimg: u32 = try trimAndParseInt(buffer[10 * 7 .. 10 * 8]);
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

    pub fn deinit(self: *DXHeader) void {
        // no memory needed to free here.
        self.* = undefined;
    }
};
