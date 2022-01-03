const std = @import("zig");
const constants = @import("../constants.zig");

pub const DXADD3 = struct {
    nref: u8,
    nthr: u8,
    ncsref: u8,

    pub fn fromBuffer(buffer: [constants.ADD3_SIZE]u8) !DXADD3 {
        var nref = buffer[0];
        var nthr = buffer[1];
        var ncsref = buffer[2];
        return DXADD3{
            .nref = nref,
            .nthr = nthr,
            .ncsref = ncsref,
        };
    }
};
