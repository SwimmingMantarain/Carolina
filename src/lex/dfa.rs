use crate::lex::tokens::TokenType;

pub fn charClass(ch: &u8) -> u8 {
    match ch {
        b'\n' => 1,
        // Skip SL Comment
        // Skip ML Comment
        // Skip ML Comment `*`
        ch if ch.is_ascii_alphabetic() => 5,
        ch if ch.is_ascii_digit() => 6,
        b'\'' => 7,
        b'"' => 8,
        b'=' => 9,
        b':' => 10,
        b'+' => 11,
        b'-' => 12,
        b'/' => 13,
        b'*' => 14,
        b'&' => 15,
        b'|' => 16,
        b'<' => 17,
        b'>' => 18,
        b'!' => 19,
        // Skip Multi-Char tokens
        b'.' => 41,
        b',' => 42,
        b'(' => 43,
        b')' => 44,
        b'[' => 45,
        b']' => 46,
        b'{' => 47,
        b'}' => 48,
        b';' => 49,
        _ => 0,
    }
}

pub const DFA_TRANS: [[u8; 20]; 20] = [
    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], // 0: Start
    [ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 1: Newline
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 2: SL Comment
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 3: ML Comment
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 4: ML Comment `*`
    [ 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 5: Identifier
    [ 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 6: Integer
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 7: Character
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 8: String
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 9: Saw `=`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 10: Saw `:`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 11: Saw `+`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 12: Saw `-`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 13: Saw `/`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 14: Saw `*`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 15: Saw `&`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 16: Saw `|`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 17: Saw `<`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 18: Saw `>`
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 19: Saw `!`
];

pub const DFA_ACCEPT: [Option<TokenType>; 50] = [
    /* 0  Start          */ None,
    /* 1  Newline        */ None,
    /* 2  SL Comment     */ Some(TokenType::SLCOM),
    /* 3  ML Comment     */ Some(TokenType::MLCOM),
    /* 4  ML Comment `*` */ None,
    /* 5  Identifier     */ Some(TokenType::IDENT),
    /* 6  Integer        */ Some(TokenType::INT),
    /* 7  Character      */ Some(TokenType::CHAR),
    /* 8  String         */ Some(TokenType::STR),
    /* 9  Saw `=`        */ Some(TokenType::PARTIAL),
    /* 10 Saw `:`        */ Some(TokenType::PARTIAL),
    /* 11 Saw `+`        */ Some(TokenType::PARTIAL),
    /* 12 Saw `-`        */ Some(TokenType::PARTIAL),
    /* 13 Saw `/`        */ Some(TokenType::PARTIAL),
    /* 14 Saw `*`        */ Some(TokenType::PARTIAL),
    /* 15 Saw `&`        */ Some(TokenType::PARTIAL),
    /* 16 Saw `|`        */ Some(TokenType::PARTIAL),
    /* 17 Saw `<`        */ Some(TokenType::PARTIAL),
    /* 18 Saw `>`        */ Some(TokenType::PARTIAL),
    /* 19 Saw `!`        */ Some(TokenType::PARTIAL),
    /* ------------------------------------------- */
    /* 20 `==`           */ Some(TokenType::EQEQ),
    /* 21 `=`            */ Some(TokenType::EQ),
    /* 22 `:=`           */ Some(TokenType::COL_E),
    /* 23 `:`            */ Some(TokenType::COL),
    /* 24 `+=`           */ Some(TokenType::ADD_E),
    /* 25 `++`           */ Some(TokenType::INC),
    /* 26 `+`            */ Some(TokenType::ADD),
    /* 27 `-=`           */ Some(TokenType::MIN_E),
    /* 28 `--`           */ Some(TokenType::DEC),
    /* 29 `->`           */ Some(TokenType::ARR),
    /* 30 `-`            */ Some(TokenType::MIN),
    /* 31 `/`            */ Some(TokenType::DIV),
    /* 32 `*`            */ Some(TokenType::MUL),
    /* 33 `&&`           */ Some(TokenType::AND),
    /* 34 `||`           */ Some(TokenType::OR),
    /* 35 `<=`           */ Some(TokenType::LOE),
    /* 36 `<`            */ Some(TokenType::LT),
    /* 37 `>=`           */ Some(TokenType::MOE),
    /* 38 `>`            */ Some(TokenType::MT),
    /* 39 `!=`           */ Some(TokenType::NEQ),
    /* 40 `!`            */ Some(TokenType::NOT),
    /* ------------------------------------------- */
    /* 41 `.`            */ Some(TokenType::DOT),
    /* 42 `,`            */ Some(TokenType::COMMA),
    /* 43 `(`            */ Some(TokenType::LPAREN),
    /* 44 `)`            */ Some(TokenType::RPAREN),
    /* 45 `[`            */ Some(TokenType::LBRACKET),
    /* 46 `]`            */ Some(TokenType::RBRACKET),
    /* 47 `{`            */ Some(TokenType::LBRACE),
    /* 48 `}`            */ Some(TokenType::RBRACE),
    /* 49 `;`            */ Some(TokenType::SEMICOL),
];
