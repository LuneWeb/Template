use include_dir::{include_dir, Dir};
use std::{env::set_current_dir, fs, path::PathBuf};

pub fn build_dir() {
    const SRC_DIR: Dir = include_dir!("src/");
    const TEMP_DIR: &str = "./.temp";

    let temp_dir = PathBuf::from(TEMP_DIR);

    if temp_dir.exists() {
        fs::remove_dir_all(&temp_dir).expect("Failed to clean temp directory");
    }

    let src_dir = temp_dir.join("src");
    let cwd_dir = temp_dir.join("program");

    fs::create_dir_all(&src_dir).expect("Failed to create temp directory");
    fs::create_dir_all(&cwd_dir).expect("Failed to create temp directory");

    for dir in SRC_DIR.entries() {
        if let Some(file) = dir.as_file() {
            let path = src_dir.join(file.path());

            if path.exists() {
                continue;
            }

            fs::write(path, file.contents()).expect("Failed to create temp file");
        }
    }

    // we do this so things fs functions will be relative to our temp directory
    set_current_dir(cwd_dir).expect("Failed to set current directory to temp directory");
}
