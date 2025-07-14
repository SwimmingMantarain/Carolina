// Fuck the compiler
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(dead_code)]
#![allow(unused)]

mod lex;

use clap::Parser;
use std::fs;
use crate::lex::lex::lexify;

const CARO_VER: &str = "V0.0.1";

#[derive(Parser)]
#[command(name = "Carolina Compiler V0.0.1")]
#[command(version = CARO_VER)]
#[command(about = "A little toy project", long_about = None)]
struct Cli {
    #[arg(short, num_args = 1.., name = "file(s)", help = "Input file(s)", default_values_t = ["main.caro".to_string()])]
    i: Vec<String>,

    // For debug purposes :D
    #[arg(long, help = "Only invoke lexer", default_value_t = false)]
    lex: bool,
    
}


fn main() {
    let flags = Cli::parse();

    if flags.lex {
        for file in flags.i {
            let src: Vec<u8> = fs::read(file).expect("Failed to read file!");
            let tokens = lexify(&src);

            println!("{:<10} | {:<3} | {:<3} | {}", "Type", "Row", "Col", "Value");
            println!("-----------|-----|-----|-------");
            for token in tokens {
                let value = if token.ve != 0 {
                    std::str::from_utf8(&src[token.vs..token.ve]).unwrap()
                } else {
                    "-"
                };
                println!("{:<10} | {:<3} | {:<3} | {}", format!("{:?}", token.typ), token.row, token.col, value);
            }

        }
    } else {
        for file in flags.i {
            print!("Compiling `{}`\n", file);
            let src: Vec<u8> = fs::read(file).expect("Failed to read file!");
            lexify(&src);
        }
    }
}
