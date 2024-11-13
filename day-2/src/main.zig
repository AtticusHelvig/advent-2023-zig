const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;

const Game = struct { num: u32, red: u32, green: u32, blue: u32 };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var game: Game = undefined;
    var result: u32 = 0;
    var line: ?[]u8 = getLine(allocator);

    while (line != null) {
        game = Game{ .num = 0, .red = 0, .green = 0, .blue = 0 };
        parseGame(&game, line.?);
        if (isValid(&game)) {
            result += game.num;
        }
        line = getLine(allocator);
    }
    try stdout.print("{}\n", .{result});
}

pub fn getLine(allocator: Allocator) ?[]u8 {
    return stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 256) catch @panic("Failed to get the line.");
}

pub fn parseGame(game: *Game, line: []u8) void {
    var value: u32 = 0;

    for (0..line.len) |i| {
        const c = line[i];

        if (isDigit(c)) {
            value *= 10;
            value += toInt(c);
            continue;
        }
        switch (c) {
            'r' => {
                game.*.red = max(value, game.*.red);
                value = 0;
            },
            'g' => {
                game.*.green = max(value, game.*.green);
                value = 0;
            },
            'b' => {
                game.*.blue = max(value, game.*.blue);
                value = 0;
            },
            ':' => {
                game.*.num = value;
                value = 0;
            },
            else => {},
        }
    }
}

pub fn max(a: u32, b: u32) u32 {
    if (a > b) {
        return a;
    }
    return b;
}

pub fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

pub fn toInt(c: u8) u32 {
    return c - '0';
}

pub fn isValid(game: *Game) bool {
    return (game.*.red <= 12) and (game.*.green <= 13) and (game.*.blue <= 14);
}
