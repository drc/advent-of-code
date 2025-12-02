const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("==== day 1 ====\n", .{});
    print("task 1: \t{d}\n", .{try task1(file)});
    print("task 2: \t{d}\n", .{try task2(file)});
}

const Direction = enum(u8) { left = 'L', right = 'R' };

fn task1(input: []const u8) !i16 {
    var position: i16 = 50;
    var zeroes: i16 = 0;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const direction: Direction = @enumFromInt(line[0]);
        const amount = try std.fmt.parseInt(i16, line[1..], 10);
        switch (direction) {
            .left => {
                position = @mod(position - amount + 100, 100);
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

fn task2(input: []const u8) !i32 {
    var position: i32 = 50;
    var passed_zero: i32 = 0;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const direction: Direction = @enumFromInt(line[0]);
        const amount = try std.fmt.parseInt(i32, line[1..], 10);
        switch (direction) {
            .left => {
                const new_position = position - amount;

                // Count how many times we wrap around (go negative or land on 0)
                // We count the number of multiples of 100 strictly less than the starting
                // position and greater or equal to the new position. This avoids
                // counting the case where we start at 0 and immediately move away.
                if (new_position <= 0) {
                    const passes = @divFloor(position - 1, 100) + @divFloor(-new_position, 100) + 1;
                    passed_zero += @intCast(passes);
                }
                position = @mod(new_position + 100, 100);
            },
            .right => {
                const new_position = position + amount;

                // Count how many times we wrap around (go over 100)
                if (new_position >= 100) {
                    passed_zero += @divFloor(new_position, 100);
                }
                position = @mod(new_position, 100);
            },
        }
    }
    return passed_zero;
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

test "example tests" {
    {
        const result = try task1(example);
        print("\nExample Test 1: {d}\n", .{result});
        try expect(result == 3);
    }
    {
        const result = try task2(example);
        print("\nExample Test 2: {d}\n", .{result});
        try expect(result == 6);
    }
}

test "final answers" {
    {
        const result = try task1(file);
        print("\nFinal Answer Part 1: {d}\n", .{result});
        try expect(result == 1084);
    }
    {
        const result = try task2(file);
        print("\nFinal Answer Part 2: {d}\n", .{result});
        try expect(result == 6475);
    }
}

test "should pass with 1" {
    // basic pass to the left
    {
        const simple_test =
            \\L75
            \\R20
        ;
        const result = try task2(simple_test);
        try expect(result == 1);
    }

    // basic pass to the right
    {
        const simple_test =
            \\R75
            \\L20
        ;
        const result = try task2(simple_test);
        try expect(result == 1);
    }

    // Left ending on zero
    {
        const simple_test =
            \\L50
            \\R50
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Left ending on zero pt2
    {
        const simple_test =
            \\L50
            \\L50
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Right ending on zero
    {
        const simple_test =
            \\R50
            \\R50
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Right ending on zero pt2
    {
        const simple_test =
            \\R50
            \\L50
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }
}
test "should pass with 2" {
    {
        const simple_test =
            \\L200
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }

    // Basic Right 2
    {
        const simple_test =
            \\R200
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }

    // Extra pass land on 0 = 2
    {
        const simple_test =
            \\L150
            \\L50
        ;
        const result = try task2(simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }
}
