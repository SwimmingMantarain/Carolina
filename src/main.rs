use clap::Parser;

mod lex;

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
            lex::lexify(file);
        }
    } else {
        for file in flags.i {
            print!("Compiling `{}`\n", file);
            lex::lexify(file);
        }
    }
}
