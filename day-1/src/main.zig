const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var total: u32 = 0;
    var buff: ?[]u8 = stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 256) catch unreachable;
    while (buff != null) {
        total += lineTotal(buff.?);
        buff = stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 256) catch unreachable;
    }

    try stdout.print("{}\n", .{total});
}

pub fn lineTotal(line: []u8) u32 {
    var first: ?u8 = null;
    var last: ?u8 = null;

    for (line) |c| {
        if (c < '0' or c > '9') {
            continue;
        }
        if (first == null) {
            first = c;
        }
        last = c;
    }
    if (first == null or last == null) {
        return 0;
    }
    return (first.? - '0') * 10 + (last.? - '0');
}
