#[derive(Debug, Clone, Copy, PartialEq)]
pub enum TokenType {
    EOF,
    PARTIAL,
    SLCOM,
    MLCOM,

    IDENT,
    INT,
    CHAR,
    STR,

    EQ,    // =
    EQEQ,  // ==
    COL,   // :
    COL_E, // :=
    ADD,   // +
    ADD_E, // +=
    INC,   // ++
    MIN,   // -
    MIN_E, // -=
    ARR,   // ->
    DEC,   // --
    DIV,   // /
    MUL,   // *
    AND,   // &
    OR,    // |
    LT,    // <
    MT,    // >
    LOE,   // <=
    MOE,   // >=
    DOT,   // .
    NEQ,   // !=
    NOT,   // !

    LPAREN,
    RPAREN,
    LBRACKET,
    RBRACKET,
    LBRACE,
    RBRACE,
    COMMA,
    SEMICOL,
}

#[derive(Debug)]
pub struct Token {
    pub typ: TokenType,
    pub vs: usize,
    pub ve: usize,
    pub row: usize,
    pub col: usize,
}
