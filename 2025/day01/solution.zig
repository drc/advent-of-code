const std = @import("std");
const print = std.debug.print;
const file = @embedFile("./input.txt");

pub fn main() !void {
    print("==== day 1 ====\n", .{});
    const start = std.time.nanoTimestamp();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const arena_alloc = arena.allocator();
    // If run with argument "bench", run the benchmark instead of the normal run
    const mem_allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(mem_allocator);
    defer mem_allocator.free(args);
    if (args.len > 1 and std.mem.eql(u8, args[1], "bench")) {
        try benchmark();
        return;
    }
    print("task 1: \t{d}\n", .{try task1(arena_alloc, file)});
    print("task 2: \t{d}\n", .{try task2(arena_alloc, file)});
    const dur = std.time.nanoTimestamp() - start;
    print("Time: {d}μs\n", .{@divTrunc(dur, 1000)});
}

pub fn benchmark() !void {
    const page_alloc = std.heap.page_allocator;
    const count: usize = 2_000_000; // Number of moves to generate for benchmarking
    const input = try generateInput(count);
    defer page_alloc.free(input);

    print("Benchmark: parsing {d} moves\n", .{count});

    // Warm-up and measure parse using page allocator
    var total_page_parse_time: i128 = 0;
    const runs: usize = 3;
    for (0..runs) |i| {
        const start = std.time.nanoTimestamp();
        var list = try parseMoves(page_alloc, input);
        const parse_dur = std.time.nanoTimestamp() - start;
        total_page_parse_time += parse_dur;
        // Measure compute time as well
        const start_compute = std.time.nanoTimestamp();
        _ = task1FromMoves(list.items);
        _ = task2FromMoves(list.items);
        const compute_dur = std.time.nanoTimestamp() - start_compute;
        print("page_alloc run {d}: parse {d} μs, compute {d} μs\n", .{ i, @divTrunc(parse_dur, 1000), @divTrunc(compute_dur, 1000) });
        list.deinit(page_alloc);
    }
    print("page_alloc average parse time: {d} μs\n", .{@divTrunc(@divTrunc(total_page_parse_time, runs), 1000)});

    // Use arena allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    var total_arena_parse_time: i128 = 0;
    for (0..runs) |i| {
        _ = arena.reset(.free_all);
        const start = std.time.nanoTimestamp();
        var list = try parseMoves(alloc, input);
        const parse_dur = std.time.nanoTimestamp() - start;
        total_arena_parse_time += parse_dur;
        const start_compute = std.time.nanoTimestamp();
        _ = task1FromMoves(list.items);
        _ = task2FromMoves(list.items);
        const compute_dur = std.time.nanoTimestamp() - start_compute;
        print("arena run {d}: parse {d} μs, compute {d} μs\n", .{ i, @divTrunc(parse_dur, 1000), @divTrunc(compute_dur, 1000) });
        list.deinit(alloc);
    }
    print("arena average parse time: {d} μs\n", .{@divTrunc(@divTrunc(total_arena_parse_time, runs), 1000)});
    print("Benchmark complete\n", .{});
}

fn generateInput(count: usize) ![]u8 {
    const alloc = std.heap.page_allocator;
    // Each line is roughly 5 bytes on average (e.g. "L100\n"), so allocate conservatively
    const approx_size = count * 6;
    var buf = try alloc.alloc(u8, approx_size);
    var pos: usize = 0;
    var digits_buf: [16]u8 = undefined;
    for (0..count) |i| {
        // reset writer to start of buffer each iteration
        const c: u8 = if ((i & 1) == 0) 'L' else 'R';
        const amount = (i % 200) + 1; // amounts 1..200 cycles
        // write char
        buf[pos] = c;
        pos += 1;
        // write digits to digits_buf reversed
        var x: usize = @as(usize, amount);
        var d_len: usize = 0;
        while (x > 0) {
            const digit_value: u8 = @intCast(x % 10);
            digits_buf[d_len] = @as(u8, '0') + digit_value;
            x = x / 10;
            d_len += 1;
        }
        if (d_len == 0) {
            digits_buf[0] = @as(u8, '0');
            d_len = 1;
        }
        // copy digits in reverse order to buf
        var j: usize = 0;
        while (j < d_len) : (j += 1) {
            buf[pos + j] = digits_buf[d_len - 1 - j];
        }
        pos += d_len;
        // newline
        buf[pos] = '\n';
        pos += 1;
    }
    // shrink to used size
    return buf[0..pos];
}

const Direction = enum(u8) { left = 'L', right = 'R' };

const Move = struct {
    dir: Direction,
    amount: i32,
};

fn parseMoves(allocator: std.mem.Allocator, input: []const u8) !std.ArrayList(Move) {
    var list = try std.ArrayList(Move).initCapacity(allocator, 0);
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const dir: Direction = @enumFromInt(line[0]);
        const amount = try std.fmt.parseInt(i32, line[1..], 10);
        try list.append(allocator, Move{ .dir = dir, .amount = amount });
    }
    return list;
}

/// task1 parses move instructions from `input` and counts how many times the
/// position lands on zero (modulo 100) after executing each move.
///
/// The input is expected to be newline-separated lines, each starting with
/// `L` or `R` followed by a decimal integer amount (for example: "L68" or
/// "R30"). The position is a circular value in the range [0, 99], starting
/// at 50. Moving left decrements the position and moving right increments it.
///
/// allocator: A memory allocator used to allocate a temporary buffer for
///     copying each input line before parsing. An ArenaAllocator is used in
///     the tests to avoid repeated allocations, but any allocator implementing
///     std.mem.Allocator is accepted.
///
/// Returns the number of times the position equals zero after any move. Any
/// parsing errors (invalid integer parsing) are propagated as errors.
fn task1(allocator: std.mem.Allocator, input: []const u8) !i16 {
    var list = try parseMoves(allocator, input);
    defer list.deinit(allocator);
    const result = task1FromMoves(list.items);
    return result;
}

fn task1FromMoves(moves: []const Move) i16 {
    var position: i16 = 50;
    var zeroes: i16 = 0;
    for (moves) |m| {
        switch (m.dir) {
            .left => {
                const numerator_i32: i32 = @as(i32, position) - m.amount + 100;
                const new_pos_i32 = std.math.mod(i32, numerator_i32, 100) catch unreachable;
                position = @intCast(new_pos_i32);
            },
            .right => {
                const numerator_i32: i32 = @as(i32, position) + m.amount;
                const new_pos_i32 = std.math.mod(i32, numerator_i32, 100) catch unreachable;
                position = @intCast(new_pos_i32);
            },
        }
        if (position == 0) zeroes += 1;
    }
    return zeroes;
}

// Old `task2` wrapper removed; use `task2(allocator, input)` instead.

fn task2(allocator: std.mem.Allocator, input: []const u8) !i32 {
    var list = try parseMoves(allocator, input);
    defer list.deinit(allocator);
    return task2FromMoves(list.items);
}

fn task2FromMoves(moves: []const Move) i32 {
    var position: i32 = 50;
    var passed_zero: i32 = 0;
    for (moves) |m| {
        switch (m.dir) {
            .left => {
                const new_position = position - m.amount;
                if (new_position <= 0) {
                    const passes = @divFloor(position - 1, 100) + @divFloor(-new_position, 100) + 1;
                    passed_zero += @intCast(passes);
                }
                const new_pos_i32 = std.math.mod(i32, new_position + 100, 100) catch unreachable;
                position = new_pos_i32;
            },
            .right => {
                const new_position = position + m.amount;
                if (new_position >= 100) {
                    passed_zero += @divFloor(new_position, 100);
                }
                const new_pos_i32 = std.math.mod(i32, new_position, 100) catch unreachable;
                position = new_pos_i32;
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
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task1(arena_alloc, example);
        print("\nExample Test 1: {d}\n", .{result});
        try expect(result == 3);
    }
    {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, example);
        print("\nExample Test 2: {d}\n", .{result});
        try expect(result == 6);
    }
}

test "final answers" {
    {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task1(arena_alloc, file);
        print("\nFinal Answer Part 1: {d}\n", .{result});
        try expect(result == 1084);
    }
    {
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, file);
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
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        try expect(result == 1);
    }

    // basic pass to the right
    {
        const simple_test =
            \\R75
            \\L20
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        try expect(result == 1);
    }

    // Left ending on zero
    {
        const simple_test =
            \\L50
            \\R50
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Left ending on zero pt2
    {
        const simple_test =
            \\L50
            \\L50
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Right ending on zero
    {
        const simple_test =
            \\R50
            \\R50
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }

    // Right ending on zero pt2
    {
        const simple_test =
            \\R50
            \\L50
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 1);
    }
}
test "should pass with 2" {
    {
        const simple_test =
            \\L200
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }

    // Basic Right 2
    {
        const simple_test =
            \\R200
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }

    // Extra pass land on 0 = 2
    {
        const simple_test =
            \\L150
            \\L50
        ;
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const arena_alloc = arena.allocator();
        const result = try task2(arena_alloc, simple_test);
        print("\nResult: {d}\n", .{result});
        try expect(result == 2);
    }
}
