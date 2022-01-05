const std = @import("std");
pub const RECORD_SIZE: usize = 80 * 384;
pub const RECORD_HEADER_SIZE: usize = 24;
pub const RECORD_DATA_SIZE: usize = RECORD_SIZE - RECORD_HEADER_SIZE;
pub const DXS1_SIZE = 5;
pub const DXS2_SIZE = 5;
pub const DXS3_SIZE = 7;
pub const DXS4_SIZE = 9;
pub const ADD3_SIZE = 3;

pub const FileReader = std.io.BufferedReader(4096, std.fs.File.Reader).Reader;
