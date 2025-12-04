const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("=== day 3 ===\n", .{});
    print("Result Task 1: {d}\n", .{try task1(file)});
    // print("Result Task 2: {d}\n", .{try task2(file)});
}

fn task1(input: []const u8) !i32 {
    var total: i32 = 0;
    var banks = std.mem.tokenizeScalar(u8, input, '\n');

    while (banks.next()) |bank| {
        var largest_battery: u8 = 0;
        for (0..bank.len) |i| {
            for (i + 1..bank.len) |j| {
                const digit1 = bank[i] - '0';
                const digit2 = bank[j] - '0';
                const battery = digit1 * 10 + digit2;
                if (battery > largest_battery) {
                    largest_battery = battery;
                }
            }
        }
        total += largest_battery;
    }
    return total;
}

fn task2(input: []const u8) !i32 {
    var total: i32 = 0;
    var banks = std.mem.tokenizeScalar(u8, input, '\n');

    while (banks.next()) |bank| {
        var largest_battery: u8 = 0;
        for (0..bank.len) |i| {
            for (i + 1..bank.len) |j| {
                const digit1 = bank[i] - '0';
                const digit2 = bank[j] - '0';
                const battery = digit1 * 10 + digit2;
                if (battery > largest_battery) {
                    largest_battery = battery;
                }
            }
        }
        total += largest_battery;
    }
    return total;
}

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

test "day 3 final answers" {
    {
        const result = try task1(file);
        print("\nTask 1 Result: {d}\n", .{result});
        try expect(result == 17085);
    }
}

test "example 1 line 1" {
    const result = try task1("987654321111111");
    print("\nExample 1 Result: {d}\n", .{result});
    try expect(result == 98);
}

test "example 1 line 2" {
    const result = try task1("811111111111119");
    print("\nExample 2 Result: {d}\n", .{result});
    try expect(result == 89);
}

test "example 1 line 3" {
    const result = try task1("234234234234278");
    print("\nExample 3 Result: {d}\n", .{result});
    try expect(result == 78);
}

test "example 1 line 4" {
    const result = try task1("818181911112111");
    print("\nExample 4 Result: {d}\n", .{result});
    try expect(result == 92);
}

test "example 2 line 1" {
    const result = try task2("987654321111111");
    print("\nExample 1 Result: {d}\n", .{result});
    try expect(result == 98);
}

test "example 2 line 2" {
    const result = try task2("811111111111119");
    print("\nExample 2 Result: {d}\n", .{result});
    try expect(result == 89);
}

test "example 2 line 3" {
    const result = try task2("234234234234278");
    print("\nExample 3 Result: {d}\n", .{result});
    try expect(result == 78);
}

test "example 2 line 4" {
    const result = try task2("818181911112111");
    print("\nExample 4 Result: {d}\n", .{result});
    try expect(result == 92);
}
