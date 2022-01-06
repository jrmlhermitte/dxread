const std = @import("zig");
const constants = @import("../constants.zig");

pub const DXS3 = struct {
    daynit: u8,
    ithr: u8,
    vthr: u8,
    shore: u8,
    iret: u8,
    icsret: u8,
    itmp: u8,
    iprs: u8,
    icstmp: u8,
    icsprs: u8,

    pub fn fromBuffer(buffer: []const u8) DXS3 {
        return DXS3{
            .daynit = (buffer[0] & 0b10000000) >> 7,
            .ithr = (buffer[0] & 0b01110000) >> 4,
            .vthr = (buffer[0] & 0b00001110) >> 1,
            .shore = buffer[0] & 0b00000001,
            .iret = (buffer[1] & 0b11110000) >> 4,
            .icsret = buffer[1] & 0b00001111,
            .itmp = buffer[2],
            .iprs = buffer[3],
            .icstmp = buffer[4],
            .icsprs = buffer[5],
        };
    }

    pub fn deinit(self: *DXS3) void {
        self.* = undefined;
    }
};
