const std = @import("std");
const fs = std.fs;
const constants = @import("../constants.zig");
const logger = @import("../logger.zig").logger;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecord = @import("dx_record.zig").DXRecord;

/// DX Data
/// See section 2.3.3 [here](https://isccp.giss.nasa.gov/pub/documents/d-doc.pdf)
/// for a full description of this data format.
pub const DXData = struct {
    /// Header
    header: DXHeader,
    /// List of records within the dx data file.
    records: std.ArrayList(DXRecord),

    pub fn readFromFile(filename: []const u8, allocator: *std.mem.Allocator) !DXData {
        const real_filename = try std.fs.realpathAlloc(allocator.*, filename);
        defer allocator.free(real_filename);
        var file = try std.fs.openFileAbsolute(real_filename, .{});
        defer file.close();

        var buf_reader = std.io.bufferedReader(file.reader()).reader();
        return DXData.readFromReader(buf_reader, allocator);
    }

    pub fn readFromReader(file_reader: constants.FileReader, allocator: *std.mem.Allocator) !DXData {
        var record_buffer = try file_reader.readBytesNoEof(constants.RECORD_SIZE);
        var record_reader: constants.RecordReader = std.io.fixedBufferStream(record_buffer[0..]).reader();
        var header = try DXHeader.fromReader(record_reader);
        var numRecords: u64 = 0;
        var records = std.ArrayList(DXRecord).init(allocator.*);
        while (true) {
            record_buffer = file_reader.readBytesNoEof(constants.RECORD_SIZE) catch break;
            record_reader = std.io.fixedBufferStream(record_buffer[0..]).reader();
            var record = try DXRecord.fromReader(record_reader, header, allocator);
            try records.append(record);
            numRecords += 1;
        }
        logger.debug("number records: {d}", .{numRecords});
        logger.debug(" value: {any}", .{header});
        return DXData{
            .header = header,
            .records = records,
        };
    }
};
