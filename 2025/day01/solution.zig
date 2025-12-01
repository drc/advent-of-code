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

const expect = std.testing.expect;

test "aoc example task 1" {
    const result = try task1(example);
    print("{}\n\n", .{result});
    try expect(result == 3);
}

test "aoc example task 2" {
    try task2();
}

const Direction = enum(u8) { left = 'L', right = 'R' };

fn task1(input: []const u8) !i8 {
    var position: i16 = 50;
    var zeroes: i8 = 0;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const direction: Direction = @enumFromInt(line[0]);
        const amount = try std.fmt.parseInt(i16, line[1..], 10);

        print("\n[{d}] == {t} - {d}\n", .{ position, direction, amount });

        switch (direction) {
            .left => {
                // const new_pos: i16 = @intCast(@abs(position - amount));
                position = @mod(position - amount, 100);
            },
            .right => {
                position = @mod(position + amount, 100);
            },
        }
        if (position == 0) {
            zeroes += 1;
        }
    }
    return @intCast(zeroes);
}

fn task2() !void {}
