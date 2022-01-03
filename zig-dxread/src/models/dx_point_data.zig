const std = @import("std");
const constants = @import("../constants.zig");
const logger = @import("../logger.zig").logger;
const DXHeader = @import("dx_header.zig").DXHeader;
const DXRecordHeader = @import("dx_record_header.zig").DXRecordHeader;
const DXS1 = @import("dx_s1.zig").DXS1;
const DXADD1 = @import("dx_add1.zig").DXADD1;
const DXS2 = @import("dx_s2.zig").DXS2;
const DXS3 = @import("dx_s3.zig").DXS3;
const DXADD3 = @import("dx_add3.zig").DXADD3;
const DXS4 = @import("dx_s4.zig").DXS4;

pub const DXPointData = struct {
    dx_s1: DXS1,
    dx_add1: ?DXADD1,
    dx_s2: ?DXS2,
    dx_s3: DXS3,
    dx_add3: ?DXADD3,
    dx_s4: ?DXS4,

    pub fn fromReader(
        reader: constants.RecordReader,
        header: DXHeader,
        allocator: *std.mem.Allocator,
    ) !DXPointData {
        // NOTE: each fromReader call seeks through the buffer.
        // ex: the fromReader call below will consume 5 bytes from the buffer
        var s1_buffer = try reader.readBytesNoEof(constants.DXS1_SIZE);
        var dx_s1 = DXS1.fromBuffer(s1_buffer) catch |err| {
            logger.debug("Error reading dxs1 data: {}", .{err});
            return err;
        };
        var nbytes = header.nchans - 2;
        var dx_add1: ?DXADD1 = null;
        if (nbytes > 0) {
            logger.debug("Reading {d} bytes for dxadd1 data", .{nbytes});
            var add1_buffer = try allocator.alloc(u8, nbytes);
            defer allocator.free(add1_buffer);
            _ = try reader.read(add1_buffer);
            dx_add1 = DXADD1.fromBuffer(add1_buffer, allocator) catch |err| {
                logger.debug("Error reading dxadd1 data: {}", .{err});
                return err;
            };
        }
        var dx_s2: ?DXS2 = null;
        if (dx_s1.noday == 0) {
            // logger.debug("Reading dxs2 data", .{});
            // 5 bytes
            var s2_buffer = try reader.readBytesNoEof(constants.DXS2_SIZE);
            dx_s2 = DXS2.fromBuffer(s2_buffer) catch |err| {
                logger.debug("Error reading dxs2 data: {}", .{err});
                return err;
            };
        }

        var s3_buffer = try reader.readBytesNoEof(constants.DXS3_SIZE);
        var dx_s3 = DXS3.fromBuffer(s3_buffer) catch |err| {
            logger.debug("Error reading dxs3 data: {}", .{err});
            return err;
        };

        var dx_add3: ?DXADD3 = null;
        if (header.sattyp == -3 or header.sattyp == 1 or header.sattyp == 2) {
            logger.debug("Reading dxadd3 data", .{});
            var add3_buffer = try reader.readBytesNoEof(constants.ADD3_SIZE);
            dx_add3 = DXADD3.fromBuffer(add3_buffer) catch |err| {
                logger.debug("Error reading dxadd3 data: {}", .{err});
                return err;
            };
        }

        var dx_s4: ?DXS4 = null;
        if (dx_s1.noday == 0) {
            // logger.debug("Reading dxs4 data", .{});
            var s4_buffer = try reader.readBytesNoEof(constants.DXS4_SIZE);
            dx_s4 = DXS4.fromBuffer(s4_buffer) catch |err| {
                logger.debug("Error reading dxs4 data: {}", .{err});
                return err;
            };
        }

        return DXPointData{
            .dx_s1 = dx_s1,
            .dx_add1 = dx_add1,
            .dx_s2 = dx_s2,
            .dx_s3 = dx_s3,
            .dx_add3 = dx_add3,
            .dx_s4 = dx_s4,
        };
    }
    //https://isccp.giss.nasa.gov/pub/documents/d-doc.pdf
};
