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

    pub fn fromBuffer(buffer: [constants.DXS3_SIZE]u8) !DXS3 {
        var daynit = (buffer[0] & 0b10000000) >> 7;
        var ithr = (buffer[0] & 0b01110000) >> 4;
        var vthr = (buffer[0] & 0b00001110) >> 1;
        var shore = buffer[0] & 0b00000001;
        var iret = (buffer[1] & 0b11110000) >> 4;
        var icsret = buffer[1] & 0b00001111;
        var itmp = buffer[2];
        var iprs = buffer[3];
        var icstmp = buffer[4];
        var icsprs = buffer[5];
        return DXS3{
            .daynit = daynit,
            .ithr = ithr,
            .vthr = vthr,
            .shore = shore,
            .iret = iret,
            .icsret = icsret,
            .itmp = itmp,
            .iprs = iprs,
            .icstmp = icstmp,
            .icsprs = icsprs,
        };
    }
};
