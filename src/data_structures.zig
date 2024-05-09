const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const Allocator = mem.Allocator;
const stdout = std.io.getStdOut().writer();

pub fn Stack(comptime T: type) type {
    return struct {
        const Node = struct {
            data: T,
            next: ?*Node = null,
        };
        const Self = @This();

        head: ?*Node = null,
        size: usize = 0,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            return Self{
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            var current = self.head;

            while (current) |item| {
                defer self.allocator.destroy(item);
                current = item.next;
                self.size -= 1;
            }
            self.head = null;
        }

        pub fn push(self: *Self, data: T) Allocator.Error!void {
            const node = try self.allocator.create(Node);
            node.data = data;
            node.next = self.head;

            self.head = node;
            self.size += 1;
        }

        pub fn pop(self: *Self) ?T {
            const head = self.head orelse return null;
            defer self.allocator.destroy(head);
            self.head = head.next;
            return head.data;
        }

        pub fn peek(self: *Self) error{EmptyStack}!T {
            const head = self.head orelse return error.EmptyStack;

            return head.data;
        }

        pub fn print_stack(self: *Self) !void {
            var current = self.head;

            while (current) |item| {
                try stdout.print("The node value is: {any}\n", .{item.data});
                current = item.next;
            }
        }
    };
}

test "pop empty stack" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    _ = stack.pop();
    try stack.push(21);
    _ = stack.pop();
    _ = stack.pop();
}

test "simple allocation" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    try stack.push(20);
    try stack.push(10);
    try stack.push(21);
    try stack.push(23);

    try testing.expectEqual(@as(i32, 23), stack.peek());
    try testing.expectEqual(@as(?i32, 23), stack.pop());
    try testing.expectEqual(@as(i32, 21), stack.peek());
}

test "bool datatype" {
    var stack = Stack(bool).init(testing.allocator);
    defer stack.deinit();

    try stack.push(true);
    try testing.expectEqual(true, stack.peek());
}

test "size of stack" {
    var stack = Stack(i32).init(testing.allocator);
    defer stack.deinit();

    try stack.push(20);
    try stack.push(10);
    try stack.push(21);
    try stack.push(23);

    try testing.expect(stack.size == 4);
}
