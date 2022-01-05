const std = @import("std");
const RECORD_SIZE: usize = 80 * 384;
const logger = std.log.scoped(.dxread);
const DXData = @import("models/dx_data.zig").DXData;

const BufferError = error{BufferExhausted};

test "sample file" {
    const filename = "../../data/ISCCP.DX.0.GOE-7.1991.01.01.0000.AES";
    const sample_data = @embedFile(filename);
    var reader = std.io.fixedBufferStream(sample_data).reader();
    _ = try DXData.readFromReader(reader);
}

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        var leaks = gpa.deinit();
        if (leaks) {
            logger.info("WARNING, found leaks: {}", .{leaks});
        }
    }
    var arena_allocator = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena_allocator.deinit();
    var allocator = arena_allocator.allocator();
    const filename = "../data/ISCCP.DX.0.GOE-7.1991.01.01.0000.AES";
    var dx_data = try DXData.readFromFile(filename, allocator);
    logger.info("DXData header: {}", .{dx_data.header});
}
