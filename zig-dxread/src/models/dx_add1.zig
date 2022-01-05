const std = @import("std");
const constants = @import("../constants.zig");

pub const DXADD1 = struct {
    arad: std.ArrayList(u8),

    pub fn sizeBytes(self: *DXADD1) usize {
        return self.arad.items.len;
    }

    pub fn fromBuffer(
        allocator: std.mem.Allocator,
        buffer: []const u8,
    ) !DXADD1 {
        var arad: std.ArrayList(u8) = std.ArrayList(u8).init(allocator);
        for (buffer) |item| {
            try arad.append(item);
        }
        return DXADD1{ .arad = arad };
    }

    pub fn deinit(self: *DXADD1) void {
        self.arad.deinit();
        self.* = undefined;
    }
};
