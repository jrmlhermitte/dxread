const std = @import("std");
const fs = std.fs;
const gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator;
const ArrayList = std.ArrayList;
const erorset_1 = error{OutOfMemory};

const RECORD_SIZE = 80 * 384;

const DX_header = struct {
    year: u32,
    month: u32,
    day: u32,
    utc: u32,
    satid: u32,
    sattyp: u32,
    nchans: u32,
    nghtimg: u32,
};

const DX_data = struct {
    header: DX_header,
};


pub fn readHeader(buffer: [RECORD_SIZE]u8) !DX_header {
    // std.log.info("{any}", .{buffer});
    std.log.info("value: {any}", .{buffer[10]});
    var year: u32 = 1; //try std.fmt.parseInt(u32, buffer[0..8], 10);
    return DX_header{
        .year = year,
        .month = 0,
        .day = 0,
        .utc = 0,
        .satid = 0,
        .sattyp = 0,
        .nchans = 0,
        .nghtimg = 0,
    };
}

pub fn readFile(filename: [] const u8) !DX_data {
    var file = try std.fs.openFileAbsolute(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [RECORD_SIZE]u8 = try in_stream.readBytesNoEof(RECORD_SIZE);
    std.log.info("First few bytes: {any}", .{buf[0..10]});
    var header = try readHeader(buf);
    std.log.info(" value: {any}", .{header});
    return DX_data{.header = header};
}

pub fn makeList() ArrayList(u8) {
    return ArrayList(u8).init(std.heap.page_allocator);
}

pub fn main() anyerror!void {
    // const filename = try fs.realpathAlloc(allocator, ".");
    const filename = "/home/julien/workspace/src/dxread/data/ISCCP.DX.0.GOE-7.1991.01.01.0000.AES";
    _ = try readFile(filename);
    var list = makeList();
    std.log.info("{any}", .{.{1, 2}});
    try list.append('f');

    // defer allocator.free(filename);
    // std.log.info("Found file with name {filename}", .{filename});
    // readFile(filename) catch |err| std.log.info("{}, {}", .{err, filename});
}

