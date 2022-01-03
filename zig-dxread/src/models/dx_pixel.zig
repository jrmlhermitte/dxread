const std = @import("std");
const range = @import("../range.zig").range;
const constants = @import("../constants.zig");
const logger = @import("../logger.zig").logger;
const DXPoint = @import("dx_point.zig").DXPoint;
const DXPointData = @import("dx_point_data.zig").DXPointData;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecordHeader = @import("dx_record_header.zig").DXRecordHeader;

pub const DXPixel = struct {
    point: DXPoint,
    data: DXPointData,

    pub fn fromReader(reader: constants.RecordReader, header: DXHeader, record_header: DXRecordHeader, allocator: *std.mem.Allocator) !std.ArrayList(DXPixel) {
        var points = std.ArrayList(DXPoint).init(allocator.*);
        var points_data = std.ArrayList(DXPointData).init(allocator.*);
        defer points.deinit();
        defer points_data.deinit();
        var pixels = std.ArrayList(DXPixel).init(allocator.*);

        logger.debug("Reading {} pixels", .{record_header.npix});
        for (range(record_header.npix)) |_| {
            var point = DXPoint.fromReader(reader) catch |err| {
                logger.debug("Error reading pixel: {}", .{err});
                return err;
            };
            try points.append(point);
        }
        for (range(record_header.npix)) |_| {
            var point_data = DXPointData.fromReader(reader, header, allocator) catch |err| {
                logger.debug("Error reading pixel data: {}", .{err});
                return err;
            };
            try points_data.append(point_data);
        }
        for (range(record_header.npix)) |_, index| {
            var pixel = DXPixel{
                .point = points.items[index],
                .data = points_data.items[index],
            };
            try pixels.append(pixel);
        }
        return pixels;
    }
};
