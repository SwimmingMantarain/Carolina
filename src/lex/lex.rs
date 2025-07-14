use crate::lex::dfa::{DFA_ACCEPT, DFA_TRANS, charClass};
use crate::lex::tokens::{Token, TokenType};

pub fn lexify(src: &Vec<u8>) -> Vec<Token> {
    let mut tokens = Vec::new();
    let mut state = 0;
    let mut vs = 0;
    let mut row = 1;
    let mut col = 1;

    for (i, ch) in src.iter().enumerate() {
        // Whitespace
        if matches!(*ch, b' ' | b'\t' | b'\r') {
            col += 1;
            continue;
        } else if *ch == b'\n' {
            col = 0;
            row += 1;
        }

        let cc = charClass(&ch);

        // Single character Tokens
        if cc >= 41 {
            let tt: TokenType = DFA_ACCEPT[cc as usize].expect("¯\\_(ツ)_/¯");
            tokens.push(Token {
                typ: tt,
                vs: i,
                ve: 1 + i,
                row: row,
                col: col,
            });
            state = 0;
            col += 1;
            continue;
        }

        col += 1;
    }

    // Add EOF token
    tokens.push(Token {
        typ: TokenType::EOF,
        vs: src.len(),
        ve: src.len(),
        row: row,
        col: col,
    });

    tokens
}
