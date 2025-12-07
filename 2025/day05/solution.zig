const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    print("=== day 5 ===\n", .{});
    print("Task 1: {d}\n", .{try task1(alloc, file)});
    print("Task 2: {d}\n", .{try task2(alloc, file)});
}

fn task1(alloc: std.mem.Allocator, input: []const u8) !usize {
    var split_input = std.mem.tokenizeSequence(u8, input, "\n\n");
    const ingredient_list = split_input.next().?;
    const fresh_ingredients = split_input.next().?;

    var available_ingredient_ids = std.AutoHashMap(usize, void).init(alloc);
    defer available_ingredient_ids.deinit();

    var fresh_lines = std.mem.tokenizeScalar(u8, fresh_ingredients, '\n');
    while (fresh_lines.next()) |f_line| {
        const fresh = std.fmt.parseInt(usize, f_line, 10) catch unreachable;
        var ingredient_lines = std.mem.tokenizeScalar(u8, ingredient_list, '\n');
        while (ingredient_lines.next()) |line| {
            var ingredient_range = std.mem.tokenizeScalar(u8, line, '-');
            const start_str = ingredient_range.next().?;
            const end_str = ingredient_range.next().?;
            const start = std.fmt.parseInt(usize, start_str, 10) catch unreachable;
            const end = std.fmt.parseInt(usize, end_str, 10) catch unreachable;
            // within range, including start / end
            if (start <= fresh and fresh <= end) {
                try available_ingredient_ids.put(fresh, {});
                break;
            }
        }
    }
    return available_ingredient_ids.count();
}

const Range = struct {
    start: usize,
    end: usize,
};

fn rangeSorter(_: void, left: Range, right: Range) bool {
    return left.start < right.start;
}

fn task2(alloc: std.mem.Allocator, input: []const u8) !usize {
    var split_input = std.mem.tokenizeSequence(u8, input, "\n\n");
    const ingredient_list = split_input.next().?;

    var available_ingredient_ids = try std.ArrayList(Range).initCapacity(alloc, 0);
    defer available_ingredient_ids.deinit(alloc);

    var ingredient_lines = std.mem.tokenizeScalar(u8, ingredient_list, '\n');
    while (ingredient_lines.next()) |line| {
        var ingredient_range = std.mem.tokenizeScalar(u8, line, '-');
        const start_str = ingredient_range.next().?;
        const end_str = ingredient_range.next().?;
        const start = std.fmt.parseInt(usize, start_str, 10) catch unreachable;
        const end = std.fmt.parseInt(usize, end_str, 10) catch unreachable;
        try available_ingredient_ids.append(alloc, Range{ .start = start, .end = end });
    }

    std.sort.heap(Range, available_ingredient_ids.items, {}, rangeSorter);

    var total: usize = 0;
    var current: usize = 0;
    for (0..available_ingredient_ids.items.len) |index| {
        var start = available_ingredient_ids.items[index].start;
        const end = available_ingredient_ids.items[index].end;
        if (current >= start) {
            start = current + 1;
        }
        if (start <= end) {
            total += end - start + 1;
        }
        current = @max(current, end);
    }
    return total;
}

const example =
    \\3-5
    \\10-14
    \\16-20
    \\12-18
    \\
    \\1
    \\5
    \\8
    \\11
    \\17
    \\32
;

const expect = std.testing.expect;

test "Example 1" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(alloc, example);
    print("Result : {d}\n", .{result});
    try expect(result == 3);
}

test "Example 2" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 2 ===\n\n", .{});
    const result = try task2(alloc, example);
    print("Result : {d}\n", .{result});
    try expect(result == 14);
}

test "Part 1 Solution" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("=== Part 1 ===\n\n", .{});
    const result = try task1(alloc, file);
    print("Result : {d}\n", .{result});
    try expect(result == 775);
}

test "Part 2 Solution" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("=== Part 2 ===\n\n", .{});
    const result = try task2(alloc, file);
    print("Result : {d}\n", .{result});
    try expect(result == 350684792662845);
}
