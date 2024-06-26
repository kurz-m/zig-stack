const std = @import("std");
const data_structure = @import("data_structure.zig");
const Stack = data_structure.Stack;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var stack = Stack(i32).init(allocator);
    defer stack.deinit();

    stack.push(21) catch |err| {
        std.debug.print("Got an error: {}\n", .{err});
    };
    try stack.push(42);
    try stack.print_stack();
}
