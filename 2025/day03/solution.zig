const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    // defer _ = gpa.deinit();
    // const allocator = gpa.allocator();
    var buffer: [128]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    print("=== day 3 ===\n", .{});
    print("Result Task 1: {d}\n", .{try task1(file)});
    print("Result Task 2: {d}\n", .{try task2(allocator, file)});
}

fn task1(input: []const u8) !i32 {
    var total: i32 = 0;
    var banks = std.mem.tokenizeScalar(u8, input, '\n');

    while (banks.next()) |bank| {
        var largest_battery: u8 = 0;
        for (0..bank.len) |i| {
            for (i + 1..bank.len) |j| {
                const digit1 = try std.fmt.charToDigit(bank[i], 10);
                const digit2 = try std.fmt.charToDigit(bank[j], 10);
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

fn task2(alloc: std.mem.Allocator, input: []const u8) !i64 {
    var total: i64 = 0;
    var banks = std.mem.tokenizeScalar(u8, input, '\n');

    while (banks.next()) |bank| {
        var bank_total: i64 = 0;
        // Use an ArrayList to store digits and manipulate more easily
        var digits = std.ArrayList(u8).initCapacity(alloc, bank.len) catch unreachable;
        defer digits.deinit(alloc);

        const target_len = 12;

        for (bank, 0..) |char, idx| {
            const digit = try std.fmt.charToDigit(char, 10);
            const remaining = bank.len - idx - 1; // digits left to process

            // remove previous digit if it's less than current and we have enough left
            while (digits.items.len > 0 and
                digits.items[digits.items.len - 1] < digit and
                digits.items.len + remaining >= target_len)
            {
                _ = digits.pop();
            }

            digits.appendAssumeCapacity(digit);
        }

        // Remove excess digits from the end
        while (digits.items.len > target_len) {
            _ = digits.pop();
        }
        // Convert to number (using wrapping arithmetic to avoid overflow)
        for (digits.items) |digit| {
            bank_total = bank_total * 10 + digit;
        }
        total += bank_total;
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
    {
        var gpa = std.heap.DebugAllocator(.{}).init;
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();
        const result = try task2(allocator, file);
        print("\nTask 2 Result: {d}\n", .{result});
        try expect(result == 169408143086082);
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
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const result = try task2(allocator, "987654321111111");
    print("\nExample 1 Result: {d}\n", .{result});
    try expect(result == 987654321111);
}

test "example 2 line 2" {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const result = try task2(allocator, "811111111111119");
    print("\nExample 2 Result: {d}\n", .{result});
    try expect(result == 811111111119);
}

test "example 2 line 3" {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const result = try task2(allocator, "234234234234278");
    print("\nExample 3 Result: {d}\n", .{result});
    try expect(result == 434234234278);
}

test "example 2 line 4" {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const result = try task2(allocator, "818181911112111");
    print("\nExample 4 Result: {d}\n", .{result});
    try expect(result == 888911112111);
}
