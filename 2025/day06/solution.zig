const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();

    print("=== day 5 ===\n", .{});
    // print("Task 1: {d}\n", .{try task1(alloc, file)});
    // print("Task 2: {d}\n", .{try task2(alloc, file)});
}

fn task1() !void {}

fn task2() !void {}

const example =
    \\123 328  51 64 
    \\45 64  387 23 
    \\6 98  215 314
    \\*   +   *   +
;

const expect = std.testing.expect;

test "Example 1" {
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(example);
    print("Result : {d}\n", .{result});
    try expect(result == 3);
}

test "Example 2" {
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(example);
    print("Result : {d}\n", .{result});
    try expect(result == 3);
}
