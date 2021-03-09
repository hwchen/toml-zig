const std = @import("std");
const Datetime = @import("datetime.zig").Datetime;

pub const Value = union(enum) {
    String: []const u8,
    Integer: i64,
    Float: f64,
    Boolean: bool,
    Datetime: Datetime,
    Array: Array,
    Table: Table,
};

pub const Array = std.ArrayList(Value);
pub const Table = std.StringHashMap(Value);
