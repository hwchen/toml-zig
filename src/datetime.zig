pub const Datetime = struct {
    date: ?Date,
    time: ?Time,
    offset: ?Offset,
};

pub const Date = struct {
    year: u16,
    month: u8,
    day: u8,
};

pub const Time = struct {
    hour: u8,
    minute: u8,
    second: u8,
    nanosecond: u32,
};

pub const Offset = union(enum) {
    Z,
    Custom: CustomOffset,
};

pub const CustomOffset = struct {
    hours: i8,
    minute: u8,
};
