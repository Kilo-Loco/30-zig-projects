const std = @import("std");

pub fn main() !void {
    const standard_writer = std.io.getStdOut().writer();
    var buf_writer = std.io.bufferedWriter(standard_writer);
    var writer = buf_writer.writer();

    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));

    var prng = std.Random.DefaultPrng.init(seed);
    const rand = prng.random();

    const selection = [4][]const u8{
        "Chili Cheese Fries",
        "Chicken Wings",
        "Hamburgers",
        "Hot Dogs",
    };
    const selectionIndex = rand.intRangeAtMost(u8, 0, selection.len - 1);
    const food = selection[selectionIndex];

    try writer.print("Randomly selected {s}\n", .{food});
    try buf_writer.flush();
}
