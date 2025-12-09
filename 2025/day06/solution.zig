const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    print("=== day 6 ===\n", .{});
    print("Task 1: {d}\n", .{try task1(file, alloc)});
    print("Task 2: {d}\n", .{try task2(file, alloc)});
}

const Operator = enum(u8) { add = '+', mult = '*' };

fn task1(input: []const u8, alloc: std.mem.Allocator) !usize {
    var grid = try std.ArrayList([][]const u8).initCapacity(alloc, 6);
    defer grid.deinit(alloc);

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var columns = try std.ArrayList([]const u8).initCapacity(alloc, 75);

        var vertical = std.mem.tokenizeScalar(u8, line, ' ');
        while (vertical.next()) |v| {
            try columns.append(alloc, v);
        }
        try grid.append(alloc, columns.items);
    }
    // transpose the elements
    const row_len = grid.items.len;
    const col_len = grid.items[0].len;

    var transposed = try std.ArrayList([][]const u8).initCapacity(alloc, col_len);
    defer transposed.deinit(alloc);

    for (0..col_len) |c| {
        var t_row = try std.ArrayList([]const u8).initCapacity(alloc, row_len);

        for (0..row_len) |r| {
            try t_row.append(alloc, grid.items[r][c]);
        }
        try transposed.append(alloc, try t_row.toOwnedSlice(alloc));
    }
    var heavy_total: usize = 0;
    for (0..transposed.items.len) |r| {
        var lite_total: usize = 0;
        std.mem.reverse([]const u8, transposed.items[r]);
        // the the char byte
        const op: Operator = @enumFromInt(transposed.items[r][0][0]);
        for (1..transposed.items[r].len) |c| {
            const digit = try std.fmt.parseInt(usize, transposed.items[r][c], 10);
            switch (op) {
                .add => {
                    lite_total += digit;
                },
                .mult => {
                    if (lite_total == 0) lite_total += 1;
                    lite_total *= digit;
                },
            }
        }
        heavy_total += lite_total;
    }
    return heavy_total;
}

fn task2(input: []const u8, alloc: std.mem.Allocator) !usize {
    var grid = try std.ArrayList(*std.ArrayList(u8)).initCapacity(alloc, 6);
    defer grid.deinit(alloc);

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var columns = try alloc.create(std.ArrayList(u8));
        columns.* = try std.ArrayList(u8).initCapacity(alloc, 75);

        for (0..line.len) |i| {
            try columns.append(alloc, line[i]);
        }
        std.mem.reverse(u8, columns.items);
        try grid.append(alloc, columns);
    }

    const row_len = grid.items.len;
    const col_len = grid.items[0].*.items.len;

    var transposed = try std.ArrayList(*std.ArrayList(u8)).initCapacity(alloc, col_len);
    defer transposed.deinit(alloc);

    for (0..col_len) |col_idx| {
        var row = try alloc.create(std.ArrayList(u8));
        row.* = try std.ArrayList(u8).initCapacity(alloc, row_len);
        for (0..row_len) |row_idx| {
            const item = grid.items[row_idx].*.items[col_idx];
            try row.append(alloc, item);
        }
        try transposed.append(alloc, row);
    }

    printGrid("transposed", transposed);

    // Process groups of numbers separated by empty lines
    var current_group = try std.ArrayList(usize).initCapacity(alloc, 10);
    defer current_group.deinit(alloc);

    var current_operator: ?Operator = null;
    var total_sum: usize = 0;

    for (transposed.items) |row| {
        const row_text = row.items[0..row.items.len];
        const trimmed: []const u8 = std.mem.trim(u8, row_text, &std.ascii.whitespace);

        if (trimmed.len == 0) {
            // Empty line - process current group if it has numbers
            if (current_group.items.len > 0 and current_operator != null) {
                const group_result = calculateGroupResult(current_group.items, current_operator.?);
                print("Group result: {d}\n", .{group_result});
                total_sum += group_result;
                current_group.clearAndFree(alloc);
                current_operator = null;
            }
            continue;
        }

        // Check if this row contains an operator
        if (std.mem.indexOfAny(u8, trimmed, "*+")) |op_index| {
            const operator_char = trimmed[op_index];
            current_operator = @enumFromInt(operator_char);

            // Extract number before operator if exists
            if (op_index > 0) {
                const number_part = std.mem.trim(u8, trimmed[0..op_index], &std.ascii.whitespace);
                if (number_part.len > 0) {
                    if (std.fmt.parseInt(usize, number_part, 10)) |digit| {
                        try current_group.append(alloc, digit);
                    } else |_| {
                        // Handle parsing error gracefully
                        print("Failed to parse number: '{s}'\n", .{number_part});
                    }
                }
            }
        } else {
            // Regular number - try to parse, but handle failure gracefully
            if (std.fmt.parseInt(usize, trimmed, 10)) |digit| {
                try current_group.append(alloc, digit);
            } else |_| {
                // If it's not a valid number and doesn't contain operators, skip it
                print("Skipping invalid row: '{s}'\n", .{trimmed});
            }
        }
    }

    // Process the last group if it exists
    if (current_group.items.len > 0 and current_operator != null) {
        const group_result = calculateGroupResult(current_group.items, current_operator.?);
        print("Group result: {d}\n", .{group_result});
        total_sum += group_result;
    }
    return total_sum;
}

fn calculateGroupResult(numbers: []const usize, operator: Operator) usize {
    if (numbers.len == 0) return 0;

    var result = numbers[0];

    for (numbers[1..]) |num| {
        switch (operator) {
            .add => {
                result += num;
            },
            .mult => {
                result *= num;
            },
        }
    }

    return result;
}
fn printGrid(title: []const u8, grid: std.array_list.Aligned(*std.array_list.Aligned(u8, null), null)) void {
    print("===\n", .{});
    print("{s}\n", .{title});
    for (grid.items) |row| {
        for (row.items) |item| {
            print("{c}", .{item});
        }
        print("\n", .{});
    }
    print("===\n", .{});
}

const example =
    \\123 328  51 64 
    \\ 45 64  387 23 
    \\  6 98  215 314
    \\*   +   *   +  
;

const expect = std.testing.expect;

test "Example 1" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(example, alloc);
    print("\nResult : {d}\n", .{result});
    try expect(result == 4277556);
}

test "Final Task 1" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(file, alloc);
    print("\nResult : {d}\n", .{result});
    try expect(result == 4693419406682);
}

test "Example 2" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 2 ===\n\n", .{});
    const result = try task2(example, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 3263827);
}

test "Small 1 for 2" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 2 ===\n\n", .{});
    const tester =
        \\125
        \\336
        \\ 93
        \\ 95
        \\*  
    ;
    const result = try task2(tester, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 175738745);
}

test "Final Task 2" {
    return error.SkipZigTest;
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const alloc = arena.allocator();
    // print("\n=== Test 2 ===\n\n", .{});
    // const result = try task2(file, alloc);
    // print("\nResult : {d}\n", .{result});
    // try expect(result != 8767755625664);
}
