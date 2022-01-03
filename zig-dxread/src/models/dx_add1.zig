const std = @import("std");
const constants = @import("../constants.zig");

pub const DXADD1 = struct {
    arad: std.ArrayList(u8),

    /// Read the DXAdd1 data from the reader.
    /// just loop over chans for now
    pub fn fromBuffer(
        buffer: []u8,
        allocator: *std.mem.Allocator,
    ) !DXADD1 {
        var arad: std.ArrayList(u8) = std.ArrayList(u8).init(allocator.*);
        for (buffer) |item| {
            try arad.append(item);
        }
        return DXADD1{ .arad = arad };
    }
};
