const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();

    print("=== day 6 ===\n", .{});
    // print("Task 1: {d}\n", .{try task1(file, alloc)});
    // print("Task 2: {d}\n", .{try task2(file, alloc)});
}

fn task1() !void {}

fn task2() !void {}

const example =
    \\
;

const expect = std.testing.expect;

test "Example 1" {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();
    print("\n=== Test 1 ===\n\n", .{});
    // const result = try task1(example, alloc);
    // print("\nResult : {d}\n", .{result});
    // try expect(result == 4277556);
}

test "Final Task 1" {
    return error.SkipZigTest;
}

test "Example 2" {
    return error.SkipZigTest;
}

test "Final Task 2" {
    return error.SkipZigTest;
}
