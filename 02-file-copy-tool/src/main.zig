pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const stdout = std.io.getStdOut().writer();

    // Parse arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        _ = try stdout.print("Only 3 arguments permitted\n", .{});
        return;
    }

    const srcPath = args[1];
    const dstPath = args[2];

    // Open and read file
    const fs = std.fs.cwd();
    const srcFile = fs.openFile(srcPath, .{}) catch |err| {
        _ = try stdout.print("You're making shit up. {s} isn't a file!\n{}\n", .{ srcPath, err });
        return;
    };
    defer srcFile.close();

    // Create/truncate destination file for writing
    const dstFile = try fs.createFile(dstPath, .{
        .mode = 0o644,
        .truncate = true,
    });
    defer dstFile.close();

    // Buffer for copying
    var buffer: [4096]u8 = undefined;
    while (true) {
        const bytesRead = try srcFile.read(buffer[0..]);
        if (bytesRead == 0) break; // EOF
        _ = try dstFile.write(buffer[0..bytesRead]);
    }

    // Success message
    _ = try stdout.print("Yo dawg, I heard you like {s} so we put {s} in {s}\n", .{ srcPath, srcPath, dstPath });
}

const std = @import("std");
