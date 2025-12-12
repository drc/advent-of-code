const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();

    print("=== day 7 ===\n", .{});
    print("Task 1: {d}\n", .{try task1(file)});
    print("Task 2: {d}\n", .{try task2(file)});
}

fn task1(input: []const u8) !usize {
    const beam_start = std.mem.indexOfScalarPos(u8, input, 0, 'S') orelse unreachable;
    const line_end = std.mem.indexOfScalarPos(u8, input, beam_start, '\n') orelse unreachable;

    var tree = std.bit_set.IntegerBitSet(1024).initEmpty();
    tree.set(beam_start + 1);

    var bit_dx: usize = 0;
    var splits: usize = 0;
    for (line_end + 1..input.len) |idx| {
        const b = input[idx];
        switch (b) {
            '\n' => bit_dx = 0,
            '.' => bit_dx += 1,
            '^' => {
                bit_dx += 1;
                if (tree.isSet(bit_dx)) {
                    splits += 1;
                    tree.unset(bit_dx);

                    if (bit_dx > 0) {
                        tree.set(bit_dx - 1);
                    }
                    if (bit_dx <= line_end) {
                        tree.set(bit_dx + 1);
                    }
                }
            },
            else => unreachable,
        }
        if (tree.isSet(bit_dx)) {
            print("|", .{});
        } else {
            print("{c}", .{b});
        }
    }

    return splits;
}

fn task2(input: []const u8) !usize {
    const beam_start = std.mem.indexOfScalarPos(u8, input, 0, 'S') orelse unreachable;
    const line_end = std.mem.indexOfScalarPos(u8, input, beam_start, '\n') orelse unreachable;
    print("Line end: {d}\n", .{line_end});
    var tree_b: [1024]usize = @splat(0);
    var tree = tree_b[0 .. line_end + 1];

    tree[beam_start + 1] += 1;

    var bit_dx: usize = 0;
    var splits: usize = 1;
    for (line_end + 1..input.len) |idx| {
        const b = input[idx];
        print("char: {c}\n", .{b});
        switch (b) {
            '\n' => bit_dx = 0,
            '.' => bit_dx += 1,
            '^' => {
                bit_dx += 1;
                if (bit_dx < line_end) {
                    print("bit_dx: {d}\n", .{bit_dx});
                    if (tree[bit_dx] > 0) {
                        splits += 1;

                        if (bit_dx > 0) {
                            tree[bit_dx - 1] += tree[bit_dx];
                        }
                        if (bit_dx < line_end) {
                            tree[bit_dx + 1] += tree[bit_dx];
                        }
                        tree[bit_dx] = 0;
                    }
                }
            },
            else => unreachable,
        }
        if (tree[bit_dx] > 0) {
            print("|", .{});
        } else {
            print("{c}", .{b});
        }
    }
    var total: usize = 0;
    for (tree) |v| {
        total += v;
    }

    return total;
}

const example =
    \\.......S.......
    \\...............
    \\.......^.......
    \\...............
    \\......^.^......
    \\...............
    \\.....^.^.^.....
    \\...............
    \\....^.^...^....
    \\...............
    \\...^.^...^.^...
    \\...............
    \\..^...^.....^..
    \\...............
    \\.^.^.^.^.^...^.
    \\...............
;

const expect = std.testing.expect;

test "Example 1" {
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(example);
    print("\nResult : {d}\n", .{result});
    try expect(result == 21);
}

test "Final Task 1" {
    print("\n=== Final 1 ===\n\n", .{});
    const result = try task1(file);
    print("\nResult : {d}\n", .{result});
    try expect(result == 1630);
}

test "Example 2" {
    print("\n=== Test 2 ===\n\n", .{});
    const result = try task2(example);
    print("\nResult : {d}\n", .{result});
    try expect(result == 40);
}

test "Final Task 2" {
    print("\n=== Test 2 ===\n\n", .{});
    const result = try task2(file);
    print("\nResult : {d}\n", .{result});
    try expect(result == 47857642990160);
}
