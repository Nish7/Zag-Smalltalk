const std = @import("std");
const zag = @import("../zag.zig");
const objectEncoding = zag.config.objectEncoding;
const isTest = zag.config.isTest;
const Process = zag.Process;
const Object = zag.object.Object;
const heap = zag.heap;
const Age = heap.Age;
const HeapHeader = heap.HeapHeader;
const HeapObjectPtr = heap.HeapObjectPtr;
const c = zag.object.ClassIndex;
const compileRaw = zag.execute.compileRaw;
const si = c.SmallInteger;
pub const ZERO = compileRaw(.{ si, 0 });
pub const False = compileRaw(.{c.False});
pub const True = compileRaw(.{c.True});
pub const Nil = compileRaw(.{c.UndefinedObject});
const SmallIntegerCache = compileRaw(.{
    si, -5,
    si, -4,
    si, -3,
    si, -2,
    si, -1,
    si, 0,
    si, 1,
    si, 2,
    si, 3,
    si, 4,
    si, 5,
    si, 6,
    si, 7,
    si, 8,
    si, 9,
    si, 10,
    si, 11,
    si, 12,
    si, 13,
    si, 14,
    si, 15,
    si, 16,
    si, 17,
    si, 18,
    si, 19,
    si, 20,
    si, 21,
    si, 22,
    si, 23,
    si, 24,
    si, 25,
    si, 26,
    si, 27,
    si, 28,
    si, 29,
    si, 30,
    si, 31,
    si, 32,
    si, 33,
    si, 34,
    si, 35,
    si, 36,
    si, 37,
    si, 38,
    si, 39,
    si, 40,
    si, 41,
    si, 42,
    si, 43,
    si, 44,
    si, 45,
    si, 46,
    si, 47,
    si, 48,
    si, 49,
    si, 50,
    si, 51,
    si, 52,
    si, 53,
    si, 54,
    si, 55,
    si, 56,
    si, 57,
    si, 58,
    si, 59,
    si, 60,
    si, 61,
    si, 62,
    si, 63,
    si, 64,
    si, 65,
    si, 66,
    si, 67,
    si, 68,
    si, 69,
    si, 70,
    si, 71,
    si, 72,
    si, 73,
    si, 74,
    si, 75,
    si, 76,
    si, 77,
    si, 78,
    si, 79,
    si, 80,
    si, 81,
    si, 82,
    si, 83,
    si, 84,
    si, 85,
    si, 86,
    si, 87,
    si, 88,
    si, 89,
    si, 90,
    si, 91,
    si, 92,
    si, 93,
    si, 94,
    si, 95,
    si, 96,
    si, 97,
    si, 98,
    si, 99,
    si, 100,
});
const SICacheMin = -5;
const SICacheMax = 100;
const SICache = switch (objectEncoding) {
    .cachedPtr, .taggedPtr => true,
    else => isTest,
};
pub inline fn int(i: i64, maybeProcess: ?*Process) Object {
    if (SICacheMin <= i and i <= SICacheMax)
        return Object.from(&SmallIntegerCache.objects[(i - SICacheMin) << 1], null);
    if (maybeProcess) |process| {
        const allocReturn = process.alloc(.SmallInteger, 1, null, Object, false);
        allocReturn.allocation.array(i64)[1] = i;
        return allocReturn.allocation.asObject();
    }
    unreachable;
}
test "inMemory int()" {
    std.debug.print("inMemory int()\n", .{});
}

pub const MemoryFloat = struct {
    header: HeapHeader,
    value: f64,
    fn static(v: f64) MemoryFloat {
        var mf: MemoryFloat = undefined;
        mf.init(v, .static);
        return mf;
    }
    pub inline fn init(self: *MemoryFloat, v: f64, age: Age) void {
        const u: u64 = @bitCast(v);
        const hash: u24 = @truncate(u ^ (u >> 40));
        self.header = .{ .classIndex = .Float, .hash = hash, .format = .notIndexable, .age = age, .length = 1 };
        self.value = v;
    }
};
const static = MemoryFloat.static;
pub const nanMemObject = static(std.math.nan(f64));
pub const pInfMemObject = static(std.math.inf(f64));
pub const nInfMemObject = static(-std.math.inf(f64));
pub const fZero = static(0.0);
pub const fOne = static(1.0);

const FCache = switch (objectEncoding) {
    .cachedPtr, .taggedPtr => true,
    else => false,
};
pub inline fn float(v: f64, maybeProcess: ?*Process) Object {
    if (FCache) {
        if (v == 0.0)
            return Object.from(&fZero);
        if (v == 1.0)
            return Object.from(&fOne);
    }
    if (maybeProcess) |process| {
        const allocReturn = process.alloc(.Float, 1, null, Object, false);
        allocReturn.allocation.array(f64)[1] = v;
        return allocReturn.allocation.asObject();
    }
    unreachable;
}
