const std = @import("std");
const file = @embedFile("./input.txt");
const print = std.debug.print;

pub fn main() !void {
    print("\n=== day 4 ===\n", .{});
    print("Task 1: {d}\n", .{try task1(file)});

    var f: [file.len]u8 = undefined;
    @memcpy(f[0..file.len], file);
    print("{any}\n", .{@TypeOf(f)});
    print("Task 2: {d}", .{try task2(&f)});
}

const MapIter = struct {
    x_offset: i32,
    y_offset: i32,
    center_x: u31,
    center_y: u31,
    width: u32,
    map: []const u8,

    fn next(self: *MapIter) ?u8 {
        while (true) {
            // out of 3 square bounds
            if (self.y_offset > 1) {
                return null;
            } else if (self.x_offset > 1) {
                // reset x and move y
                self.x_offset = -1;
                self.y_offset += 1;
                continue;
            }

            // after next is out of scope add 1 to x
            defer self.x_offset += 1;

            // center doesnt matter
            if (self.x_offset == 0 and self.y_offset == 0) continue;

            return self.val();
        }
    }

    fn val(self: MapIter) u8 {
        const x = self.x_offset + @as(i32, @intCast(self.center_x));
        const y = self.y_offset + @as(i32, @intCast(self.center_y));

        if (x < 0 or y < 0) return '.';

        const x_u: usize = @intCast(x);
        const y_u: usize = @intCast(y);

        if (x_u >= self.width - 1) return '.';

        if (y_u >= self.map.len / self.width) return '.';

        return self.map[self.width * y_u + x_u];
    }
};

fn task1(input: []const u8) !u32 {
    const width: u32 = @as(u32, @intCast(std.mem.indexOfScalar(u8, input, '\n') orelse unreachable)) + 1;
    const height: u32 = @intCast(input.len / width);
    var total_paper: u32 = 0;
    for (0..height) |y| {
        for (0..width - 1) |x| {
            const center = input[width * y + x];
            if (center == '@') {
                var it = MapIter{
                    .center_x = @intCast(x),
                    .center_y = @intCast(y),
                    .width = width,
                    .x_offset = -1,
                    .y_offset = -1,
                    .map = input,
                };
                var count: u8 = 0;
                while (it.next()) |c| {
                    if (c == '.') {
                        count += 1;
                    }
                }
                if (count > 4) {
                    total_paper += 1;
                }
            }
        }
    }
    return total_paper;
}

fn task2(input: []u8) !u32 {
    const width: u32 = @as(u32, @intCast(std.mem.indexOfScalar(u8, input, '\n') orelse unreachable)) + 1;
    const height: u32 = @intCast(input.len / width);
    var total_paper: u32 = 0;
    while (true) {
        var removed_paper: usize = 0;
        for (0..height) |y| {
            for (0..width - 1) |x| {
                const center = &input[width * y + x];
                if (center.* == '@') {
                    var it = MapIter{
                        .center_x = @intCast(x),
                        .center_y = @intCast(y),
                        .width = width,
                        .x_offset = -1,
                        .y_offset = -1,
                        .map = input,
                    };
                    var count: u8 = 0;
                    while (it.next()) |c| {
                        if (c == '.') {
                            count += 1;
                        }
                    }
                    if (count > 4) {
                        total_paper += 1;
                        center.* = '.';
                        removed_paper += 1;
                    }
                }
            }
        }
        if (removed_paper == 0) break;
    }

    return total_paper;
}

const example_data =
    \\..@@.@@@@.
    \\@@@.@.@.@@
    \\@@@@@.@.@@
    \\@.@@@@..@.
    \\@@.@@@@.@@
    \\.@@@@@@@.@
    \\.@.@.@.@@@
    \\@.@@@.@@@@
    \\.@@@@@@@@.
    \\@.@.@@@.@.
    \\
;

const expect = std.testing.expect;

test "example part 1" {
    const result = try task1(example_data);
    try expect(result == 13);
}

test "example part 2" {
    var buf: [example_data.len]u8 = undefined;
    @memcpy(buf[0..example_data.len], example_data);
    const result = try task2(&buf);
    try expect(result == 43);
}

test "final answer part 1" {
    const result = try task1(file);
    try expect(result == 1560);
}

test "final answer part 2" {
    var buf: [file.len]u8 = undefined;
    @memcpy(buf[0..file.len], file);
    const result = try task2(&buf);
    try expect(result == 9609);
}
