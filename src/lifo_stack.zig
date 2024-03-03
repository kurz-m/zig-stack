const std = @import("std");
const testing = std.testing;

pub fn LifoStack(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct { data: T, next: ?*Node = null };

        top: ?*Node = null,
        size: usize = 0,
    };
}
