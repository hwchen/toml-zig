const std = @import("std");
const mem = std.mem;
const unicode = @import("std").unicode;
const expect = std.testing.expect;

pub const Span = struct {
    start: usize,
    end: usize,
};

pub const Token = union(enum) {
    Whitespace: []const u8,
    Newline,
    Comment: []const u8,

    Equals,
    Period,
    Comma,
    Colon,
    Plus,
    LeftBrace,
    RightBrace,
    LeftBracket,
    RightBracket,

    Keylike: []const u8,
    String: StringToken,
};

pub const StringToken = struct {
    src: []const u8,
    val: []const u8,
    multiline: bool,
};

pub const Error = error{
    InvalidUtf8,
    InvalidCharInString,
    InvalidEscape,
    InvalidHexEscape,
    InvalidEscapeValue,
    NewlineInString,
    Unexpected,
    UnterminatedString,
    NewlineInTableKey,
    MultilineStringKey,
    EmptyTableKey,
    Wanted,
};

pub const Tokenizer = struct {
    input: []const u8,
    chars: unicode.Utf8Iterator,
    byte_idx: usize,
    char_idx: usize,

    pub fn new(input: []const u8) !Tokenizer {
        var t = Tokenizer{
            .input = input,
            .chars = (try unicode.Utf8View.init(input)).iterator(),
            .byte_idx = 0,
            .char_idx = 0,
        };

        _ = t.eatc("\u{feff}");
        return t;
    }

    pub fn one(self: *Tokenizer) ?[]const u8 {
        const char = self.chars.nextCodepointSlice() orelse return null;
        self.char_idx += 1;
        self.byte_idx += char.len;
        return char;
    }

    fn eatc(self: *Tokenizer, char: []const u8) bool {
        const peek_char = self.chars.peek(1);
        if (mem.eql(u8, char, peek_char)) {
            _ = self.one();
            return true;
        } else {
            return false;
        }
    }
};

test "invalid utf8" {}

test "parse one ascii" {
    const input = "one";
    var t = try Tokenizer.new(input);
    expect(mem.eql(u8, t.one().?, "o"));
}

test "parse one utf8" {}
