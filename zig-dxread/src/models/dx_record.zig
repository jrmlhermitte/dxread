const std = @import("std");
const constants = @import("../constants.zig");
const logger = @import("../logger.zig").logger;
const RecordReader = constants.RecordReader;
const RecordHeaderReader = constants.RecordHeaderReader;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecordHeader = @import("dx_record_header.zig").DXRecordHeader;
const DXPixel = @import("dx_pixel.zig").DXPixel;

pub const DXRecord = struct {
    header: DXRecordHeader,
    pixels: std.ArrayList(DXPixel),

    pub fn fromReader(record_reader: RecordReader, header: DXHeader, allocator: *std.mem.Allocator) !DXRecord {
        // NOTE: This data only exists in this function's stack.
        var record_header_buffer = try record_reader.readBytesNoEof(constants.RECORD_HEADER_SIZE);
        var record_header_reader: RecordHeaderReader = std.io.fixedBufferStream(record_header_buffer[0..]).reader();
        var record_header = DXRecordHeader.fromReader(record_header_reader) catch |err| {
            logger.debug("Error reading record header: {}", .{err});
            return err;
        };

        var pixels = try DXPixel.fromReader(
            record_reader,
            header,
            record_header,
            allocator,
        );
        return DXRecord{
            .header = record_header,
            .pixels = pixels,
        };
    }
};
