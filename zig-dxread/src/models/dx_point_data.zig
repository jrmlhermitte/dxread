const std = @import("std");
const constants = @import("../constants.zig");
const logger = std.log.scoped(.dx_point_data);
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

    /// Return the size that this data would have in bytes 
    /// when serialized to the DX data format.
    pub fn sizeBytes(self: *DXPointData) usize {
        var size: usize = constants.DXS1_SIZE;
        if (self.dx_add1) |_| {
            // can't use the captured variable because it is const *
            size += self.dx_add1.?.sizeBytes();
        }
        if (self.dx_s2) |_| {
            size += constants.DXS2_SIZE;
        }
        size += constants.DXS3_SIZE;
        if (self.dx_add3) |_| {
            size += constants.ADD3_SIZE;
        }
        if (self.dx_s4) |_| {
            size += constants.DXS4_SIZE;
        }
        return size;
    }

    pub fn fromBuffer(
        allocator: std.mem.Allocator,
        buffer: []const u8,
        header: DXHeader,
    ) !DXPointData {
        var cur: u32 = 0;
        // NOTE: each fromReader call seeks through the buffer.
        // ex: the fromReader call below will consume 5 bytes from the buffer
        const dx_s1 = DXS1.fromBuffer(buffer[cur .. cur + constants.DXS1_SIZE]);
        cur += constants.DXS1_SIZE;

        const nbytes = header.nchans - 2;
        var dx_add1: ?DXADD1 = null;
        if (nbytes > 0) {
            logger.debug("Reading {d} bytes for dxadd1 data", .{nbytes});
            dx_add1 = DXADD1.fromBuffer(allocator, buffer[cur .. cur + nbytes]) catch |err| {
                logger.debug("Error reading dxadd1 data: {}", .{err});
                return err;
            };
            cur += nbytes;
        }

        var dx_s2: ?DXS2 = null;
        if (dx_s1.noday == 0) {
            // logger.debug("Reading dxs2 data", .{});
            // 5 bytes
            dx_s2 = DXS2.fromBuffer(buffer[cur .. cur + constants.DXS2_SIZE]);
            cur += constants.DXS2_SIZE;
        }

        const dx_s3 = DXS3.fromBuffer(buffer[cur .. cur + constants.DXS3_SIZE]);
        cur += constants.DXS3_SIZE;

        var dx_add3: ?DXADD3 = null;
        if (header.sattyp == -3 or header.sattyp == 1 or header.sattyp == 2) {
            logger.debug("Reading dxadd3 data", .{});
            dx_add3 = DXADD3.fromBuffer(buffer[cur .. cur + constants.ADD3_SIZE]);
            cur += constants.ADD3_SIZE;
        }

        var dx_s4: ?DXS4 = null;
        if (dx_s1.noday == 0) {
            // logger.debug("Reading dxs4 data", .{});
            dx_s4 = DXS4.fromBuffer(buffer[cur .. cur + constants.DXS4_SIZE]);
            cur += constants.DXS4_SIZE;
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

    pub fn deinit(self: *DXPointData) void {
        self.dx_s1.deinit();
        self.dx_add1.deinit();
        self.dx_s2.deinit();
        self.dx_s3.deinit();
        self.dx_add3.deinit();
        self.dx_s4.deinit();
        self.* = undefined;
    }
};
