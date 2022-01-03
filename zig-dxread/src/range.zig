const std = @import("std");
// From issue https://github.com/ziglang/zig/issues/358

pub fn range(max: usize) []const void {
    return @as([]const void, &[_]void{}).ptr[0..max];
}
