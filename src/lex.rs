use std::fs;

pub fn lexify(filename: String) {
    print!("Lexifying `{}`\n", filename);

    let src: Vec<u8> = fs::read(filename).expect("Failed to read file!");

    for byte in src {
        print!("{}", char::from(byte));
    }
}
