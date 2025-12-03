const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("=== day 2 ===\n", .{});
    print("Result Task 1: {d}\n", .{try task1(file)});
    print("Result Task 2: {d}\n", .{try task2(file)});
}

fn task1(input: []const u8) !usize {
    var total: usize = 0;
    var ranges = std.mem.tokenizeScalar(u8, input, ',');
    while (ranges.next()) |r| {
        var range = std.mem.tokenizeScalar(u8, r, '-');
        const start = try std.fmt.parseInt(usize, range.next().?, 10);
        const end = try std.fmt.parseInt(usize, range.peek().?, 10);

        for (start..end + 1) |i| {
            var buffer: [32]u8 = undefined;
            const digit = try std.fmt.bufPrint(&buffer, "{d}", .{i});
            // check if the length can be split
            if (digit.len % 2 == 0) {
                const mid = digit.len / 2;
                const first = digit[0..mid];
                const last = digit[mid..];
                if (std.mem.eql(u8, first, last)) {
                    total += i;
                }
            }
        }
    }

    return total;
}

fn task2(input: []const u8) !usize {
    var total: usize = 0;
    var ranges = std.mem.tokenizeScalar(u8, input, ',');
    while (ranges.next()) |r| {
        var range = std.mem.tokenizeScalar(u8, r, '-');
        const start = try std.fmt.parseInt(usize, range.next().?, 10);
        const end = try std.fmt.parseInt(usize, range.peek().?, 10);

        for (start..end + 1) |i| {
            var buffer: [32]u8 = undefined;
            const digit = try std.fmt.bufPrint(&buffer, "{d}", .{i});
            const N = digit.len;

            // Check if the entire number is a repeated pattern
            for (1..(N / 2) + 1) |L| {
                if (@mod(N, L) == 0) {
                    const base = digit[0..L];
                    var is_repeated = true;

                    // Check if the entire digit is made by repeating base
                    var pos: usize = L;
                    while (pos < N) : (pos += L) {
                        if (!std.mem.eql(u8, digit[pos .. pos + L], base)) {
                            is_repeated = false;
                            break;
                        }
                    }

                    if (is_repeated) {
                        total += i;
                        break;
                    }
                }
            }
        }
    }

    return total;
}

const example =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

const expect = std.testing.expect;

test "day 2 example tests" {
    {
        const result = try task1(example);
        print("\nResult Task 1: {d}\n", .{result});
        try expect(result == 1227775554);
    }
    {
        const result = try task2(example);
        print("\nResult Task 2: {d}\n", .{result});
        try expect(result == 4174379265);
    }
}

test "simple task 11-22" {
    const result = try task2("11-22");
    print("\nResult Task 2: {d}\n", .{result});
    try expect(result == 33);
}

test "simple task 95-115" {
    const result = try task2("95-115");
    print("\nResult Task 2: {d}\n", .{result});
    try expect(result == 210);
}

test "simple task 998-1012" {
    const result = try task2("998-1012");
    print("\nResult Task 2: {d}\n", .{result});
    try expect(result == 2009);
}
