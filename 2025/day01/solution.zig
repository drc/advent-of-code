const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("here we are");
}

const example =
    \\L68
    \\L30
    \\R48
    \\L5
    \\R60
    \\L55
    \\L1
    \\L99
    \\R14
    \\L82
;

test "aoc example" {
    try task1(example);
}

fn task1(input: []const u8) !void {
    const starting_position = 50;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const direction = line[0];
        const amount = try std.fmt.parseInt(u8, line[1..], 10);

        print("\n[{d}] == {c} - {d}\n", .{ starting_position, direction, amount });
    }
}
