const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("=== day 3 ===\n", .{});
    print("Result Task 1: {d}\n", .{try task1(file)});
    print("Result Task 2: {d}\n", .{try task2(file)});
}
// input: []const u8
fn task1() !usize {
    // var total: usize = 0;
    // var ranges = std.mem.tokenizeScalar(u8, input, ',');
}

fn task2() !void {}

const example =
    \\987654321111111
    \\811111111111119
    \\234234234234278
    \\818181911112111
;

const expect = std.testing.expect;

test "day 3 example test" {
    {
        const result = try task1(example);
        print("\nTask 1 Result: {d}\n", .{result});
        try expect(result == 357);
    }
}

test "example line 1" {
    const result = try task1("987654321111111");
    print("\nExample 1 Result: {d}\n", .{result});
    try expect(result == 98);
}

test "example line 2" {
    const result = try task1("811111111111119");
    print("\nExample 2 Result: {d}\n", .{result});
    try expect(result == 89);
}

test "example line 3" {
    const result = try task1("234234234234278");
    print("\nExample 3 Result: {d}\n", .{result});
    try expect(result == 78);
}

test "example line 4" {
    const result = try task1("818181911112111");
    print("\nExample 4 Result: {d}\n", .{result});
    try expect(result == 92);
}
