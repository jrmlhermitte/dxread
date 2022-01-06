const std = @import("std");
const fs = std.fs;
const constants = @import("../constants.zig");
const logger = std.log.scoped(.dx_data);
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecord = @import("dx_record.zig").DXRecord;

/// DX Data
/// See section 2.3.3 [here](https://isccp.giss.nasa.gov/pub/documents/d-doc.pdf)
/// for a full description of this data format.
pub const DXData = struct {
    header: DXHeader,
    records: std.ArrayList(DXRecord),

    pub fn readFromFile(
        filename: []const u8,
        allocator: std.mem.Allocator,
    ) !DXData {
        var filepath_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
        var real_filename = try std.fs.realpath(filename, &filepath_buffer);
        var file = try std.fs.openFileAbsolute(real_filename, .{});
        defer file.close();

        var buf_reader = std.io.bufferedReader(file.reader()).reader();
        return DXData.readFromReader(allocator, buf_reader);
    }

    pub fn readFromReader(
        allocator: std.mem.Allocator,
        file_reader: constants.FileReader,
    ) !DXData {
        var record_buffer = try file_reader.readBytesNoEof(constants.RECORD_SIZE);
        var header = try DXHeader.fromBuffer(record_buffer);
        var numRecords: u64 = 0;
        var records = std.ArrayList(DXRecord).init(allocator);
        while (true) {
            record_buffer = file_reader.readBytesNoEof(constants.RECORD_SIZE) catch break;
            var record = try DXRecord.fromBuffer(allocator, &record_buffer, header);
            try records.append(record);
            numRecords += 1;
        }
        logger.debug("number records: {d}", .{numRecords});
        logger.debug(" value: {}", .{header});
        return DXData{
            .header = header,
            .records = records,
        };
    }

    pub fn deinit(self: *DXData) void {
        self.header.deinit();
        for (self.records) |record| {
            record.deinit();
        }
        self.records.deinit();
        self.* = undefined;
    }
};
