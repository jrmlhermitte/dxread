const std = @import("std");
const constants = @import("../constants.zig");
const logger = std.log.scoped(.dx_record);
const RecordReader = constants.RecordReader;
const RecordHeaderReader = constants.RecordHeaderReader;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecordHeader = @import("dx_record_header.zig").DXRecordHeader;
const DXPixel = @import("dx_pixel.zig").DXPixel;

pub const DXRecord = struct {
    header: DXRecordHeader,
    pixels: std.ArrayList(DXPixel),

    pub fn fromBuffer(
        allocator: std.mem.Allocator,
        buffer: []u8,
        header: DXHeader,
    ) !DXRecord {
        // NOTE: This data only exists in this function's stack.
        var record_header = DXRecordHeader.fromBuffer(buffer[0..constants.RECORD_HEADER_SIZE]) catch |err| {
            logger.debug("Error reading record header: {}", .{err});
            return err;
        };

        var pixels = try DXPixel.fromBuffer(
            allocator,
            buffer[constants.RECORD_HEADER_SIZE..],
            header,
            record_header,
        );
        return DXRecord{
            .header = record_header,
            .pixels = pixels,
        };
    }

    pub fn deinit(self: *DXRecord) void {
        self.header.deinit();
        for (self.pixels) |_, index| {
            self.pixels.items[index].deinit();
        }
        self.* = undefined;
    }
};
