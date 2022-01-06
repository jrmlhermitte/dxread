const std = @import("std");
const constants = @import("../constants.zig");
const logger = std.log.scoped(.dx_pixel);
const DXPoint = @import("dx_point.zig").DXPoint;
const DXPointData = @import("dx_point_data.zig").DXPointData;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecordHeader = @import("dx_record_header.zig").DXRecordHeader;

pub fn makeListOfInts(max: usize) []const void {
    return @as([]const void, &[_]void{}).ptr[0..max];
}

pub const DXPixel = struct {
    point: DXPoint,
    data: DXPointData,

    pub fn fromBuffer(
        allocator: std.mem.Allocator,
        buffer: []u8,
        header: DXHeader,
        record_header: DXRecordHeader,
    ) !std.ArrayList(DXPixel) {
        var pixels = try std.ArrayList(DXPixel).initCapacity(allocator, record_header.npix);

        // Here we read through the point information and data information at the same time.
        // Each of these are stored in separate segments so we have to keep track
        // to the pointer in the buffer where they reside.
        var pixel_cursor: u64 = 0;
        var data_cursor: u64 = 8 * record_header.npix;
        logger.debug("Reading {} pixels", .{record_header.npix});
        for (makeListOfInts(record_header.npix)) |_| {
            var point = DXPoint.fromBuffer(buffer[pixel_cursor .. pixel_cursor + 8]) catch |err| {
                logger.debug("Error reading pixel: {}", .{err});
                return err;
            };
            pixel_cursor += 8;

            // Now the data
            var point_data = DXPointData.fromBuffer(allocator, buffer[data_cursor..], header) catch |err| {
                logger.debug("Error reading pixel data: {}", .{err});
                return err;
            };
            // Each data element has a variable size in bytes, which we only
            // know after reading the data.
            data_cursor += point_data.sizeBytes();
            var pixel = DXPixel{
                .point = point,
                .data = point_data,
            };
            try pixels.append(pixel);
        }
        return pixels;
    }

    pub fn deinit(self: *DXPixel) void {
        self.point.deinit();
        self.data.deinit();
        self.* = undefined;
    }
};
