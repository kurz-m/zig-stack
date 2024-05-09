# Small implementation of a stack (data structure) in Zig

This is an implementation of a generic stack in Zig using a linked-list as base structure.
The implemented methods are the ones used by a regular stack. 
1. `push()` let's you add an element to the top of the stack.
2. `pop()` removes the last added element from the stack and returnes it's value.
3. `peek()` returns the value of the last added element without removing it.
4. `print_stack()` prints all elements within the stack.


### The usage is as follows:

```zig
const std = @import("std");
const data_structure = @import("data_structure.zig");
const Stack = data_structure.Stack;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var stack = Stack(i32).init(allocator);
    defer stack.deinit();

    // either like this to do something with the error
    stack.push(21) catch |err| {
        std.debug.print("Got an error: {}\n", .{err});
    };

    // or like this to propagate the error one function level higher
    try stack.push(42);

    // pop last element from the stack
    _ = stack.pop();

    // peek returns the top element of the stack without removing it
    _ = stack.peek();

    try stack.print_stack();
}
```
