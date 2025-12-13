const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    print("=== day 8 ===\n", .{});
    print("Task 1: {d}\n", .{try task1(file, alloc)});
    print("Task 2: {d}\n", .{try task2(file, alloc)});
}

const Point = struct {
    x: usize,
    y: usize,
    z: usize,
};

fn task1(input: []const u8, alloc: std.mem.Allocator) !usize {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var points = try std.ArrayList(Point).initCapacity(alloc, 10);
    while (lines.next()) |line| {
        var coords = std.mem.tokenizeScalar(u8, line, ',');
        const point = Point{
            .x = try std.fmt.parseInt(usize, coords.next().?, 10),
            .y = try std.fmt.parseInt(usize, coords.next().?, 10),
            .z = try std.fmt.parseInt(usize, coords.next().?, 10),
        };
        try points.append(alloc, point);
    }

    var pairs = try std.ArrayList([2]usize).initCapacity(alloc, 100);
    for (0..points.items.len) |i| {
        for (i + 1..points.items.len) |j| {
            try pairs.append(alloc, [2]usize{ i, j });
        }
    }

    // sort by increasing length
    std.sort.block([2]usize, pairs.items, points.items, struct {
        fn lessThanPair(pts: []const Point, a: [2]usize, b: [2]usize) bool {
            const dist_a = calculateDistance(pts[a[0]], pts[a[1]]);
            const dist_b = calculateDistance(pts[b[0]], pts[b[1]]);
            return dist_a < dist_b;
        }
    }.lessThanPair);

    var pair_range = try std.ArrayList(usize).initCapacity(alloc, points.items.len);
    for (0..points.items.len) |i| {
        try pair_range.append(alloc, i);
    }
    const rounds: usize = if (points.items.len == 20) 10 else 1000;
    for (pairs.items[0..@min(rounds, points.items.len)]) |pair| {
        merge(pair_range.items, pair[0], pair[1]);
    }

    var sizes = try alloc.alloc(u8, points.items.len);
    @memset(sizes, 0);

    for (0..points.items.len) |i| {
        sizes[root(pair_range.items, i)] += 1;
    }

    std.sort.block(u8, sizes, {}, struct {
        fn lessThan(_: void, a: u8, b: u8) bool {
            return a > b;
        }
    }.lessThan);

    return @as(usize, sizes[0]) * @as(usize, sizes[1]) * @as(usize, sizes[2]);
}

fn root(pair_range: []usize, index: usize) usize {
    if (pair_range[index] == index) return pair_range[index];
    pair_range[index] = root(pair_range, pair_range[index]);
    return pair_range[index];
}

fn merge(pair_range: []usize, a: usize, b: usize) void {
    pair_range[root(pair_range, a)] = root(pair_range, b);
}

fn calculateDistance(p1: Point, p2: Point) f64 {
    const dx = @as(f64, @floatFromInt(p1.x)) - @as(f64, @floatFromInt(p2.x));
    const dy = @as(f64, @floatFromInt(p1.y)) - @as(f64, @floatFromInt(p2.y));
    const dz = @as(f64, @floatFromInt(p1.z)) - @as(f64, @floatFromInt(p2.z));
    return std.math.hypot(std.math.hypot(dx, dy), dz);
}

fn task2(input: []const u8, alloc: std.mem.Allocator) !usize {
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var points = try std.ArrayList(Point).initCapacity(alloc, 10);
    while (lines.next()) |line| {
        var coords = std.mem.tokenizeScalar(u8, line, ',');
        const point = Point{
            .x = try std.fmt.parseInt(usize, coords.next().?, 10),
            .y = try std.fmt.parseInt(usize, coords.next().?, 10),
            .z = try std.fmt.parseInt(usize, coords.next().?, 10),
        };
        try points.append(alloc, point);
    }

    var pairs = try std.ArrayList([2]usize).initCapacity(alloc, 100);
    for (0..points.items.len) |i| {
        for (i + 1..points.items.len) |j| {
            try pairs.append(alloc, [2]usize{ i, j });
        }
    }

    // sort by increasing length
    std.sort.block([2]usize, pairs.items, points.items, struct {
        fn lessThanPair(pts: []const Point, a: [2]usize, b: [2]usize) bool {
            const dist_a = calculateDistance(pts[a[0]], pts[a[1]]);
            const dist_b = calculateDistance(pts[b[0]], pts[b[1]]);
            return dist_a < dist_b;
        }
    }.lessThanPair);

    var pair_range = try std.ArrayList(usize).initCapacity(alloc, points.items.len);
    for (0..points.items.len) |i| {
        try pair_range.append(alloc, i);
    }

    var circuits: usize = points.items.len;
    var total: usize = 0;

    for (pairs.items) |pair| {
        if (root(pair_range.items, pair[0]) == root(pair_range.items, pair[1])) {
            continue;
        }
        merge(pair_range.items, pair[0], pair[1]);
        circuits -= 1;
        if (circuits == 1) {
            total = @as(usize, points.items[pair[0]].x) * @as(usize, points.items[pair[1]].x);
        }
    }
    return total;
}

const example =
    \\162,817,812
    \\57,618,57
    \\906,360,560
    \\592,479,940
    \\352,342,300
    \\466,668,158
    \\542,29,236
    \\431,825,988
    \\739,650,466
    \\52,470,668
    \\216,146,977
    \\819,987,18
    \\117,168,530
    \\805,96,715
    \\346,949,466
    \\970,615,88
    \\941,993,340
    \\862,61,35
    \\984,92,344
    \\425,690,689
;

const expect = std.testing.expect;

test "Example 1" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 1 ===\n\n", .{});
    const result = try task1(example, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 40);
}

test "Final Task 1" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Final 1 ===\n\n", .{});
    const result = try task1(file, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 98696);
}

test "Example 2" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Test 2 ===\n\n", .{});
    const result = try task2(example, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 25272);
}

test "Final Task 2" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    print("\n=== Final 2 ===\n\n", .{});
    const result = try task2(file, alloc);
    print("Result : {d}\n", .{result});
    try expect(result == 2245203960);
}
