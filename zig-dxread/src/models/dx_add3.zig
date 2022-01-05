const std = @import("zig");
const constants = @import("../constants.zig");

pub const DXADD3 = struct {
    nref: u8,
    nthr: u8,
    ncsref: u8,

    pub fn fromBuffer(buffer: []const u8) DXADD3 {
        const nref = buffer[0];
        const nthr = buffer[1];
        const ncsref = buffer[2];
        return DXADD3{
            .nref = nref,
            .nthr = nthr,
            .ncsref = ncsref,
        };
    }

    pub fn deinit(self: *DXADD3) void {
        // No memory needed to free here
        self.* = undefined;
    }
};
