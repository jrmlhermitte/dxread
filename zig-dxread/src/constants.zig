const std = @import("std");
pub const RECORD_SIZE: usize = 80 * 384;
pub const RECORD_HEADER_SIZE: usize = 24;
pub const DXS1_SIZE = 5;
pub const DXS2_SIZE = 5;
pub const DXS3_SIZE = 7;
pub const DXS4_SIZE = 9;
pub const ADD3_SIZE = 3;

// This is private in std.io.fixed_buffer_stream so I am pulling it out.
fn NonSentinelSpan(comptime T: type) type {
    var ptr_info = @typeInfo(std.mem.Span(T)).Pointer;
    ptr_info.sentinel = null;
    return @Type(std.builtin.TypeInfo{ .Pointer = ptr_info });
}

pub fn BufferStreamReader(comptime record_size: usize) type {
    return std.io.FixedBufferStream(NonSentinelSpan(*[record_size]u8)).Reader;
}

// Readers
// Used to read the file
pub const FileReader = std.io.BufferedReader(4096, std.fs.File.Reader).Reader;
// We read chunks into separate buffers with a Reader interface for
// better readability. Each buffer loader has it's own reader type.
pub const RecordReader = BufferStreamReader(RECORD_SIZE);
pub const RecordHeaderReader = BufferStreamReader(RECORD_HEADER_SIZE);
