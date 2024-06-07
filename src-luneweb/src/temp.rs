use include_dir::{include_dir, Dir, File};
use std::{
    env::set_current_dir,
    fs,
    path::{Path, PathBuf},
};

fn is_script(path: &Path) -> bool {
    let Some(ext) = path.extension() else {
        return false;
    };

    matches!(ext.to_str().unwrap(), "luau" | "lua")
}

fn move_dir(parent: &PathBuf, dir: &Dir) {
    for dir in dir.entries() {
        if let Some(file) = dir.as_file() {
            if !is_script(dir.path()) {
                write_file(parent, file);
            }
        } else if let Some(dir) = dir.as_dir() {
            let path = parent.join(dir.path());

            fs::create_dir_all(&path).expect("Failed to create temp directory");

            move_dir(parent, dir);
        }
    }
}

fn write_file(parent: &Path, file: &File) {
    let path = parent.join(file.path());

    if path.exists() {
        return;
    }

    fs::write(path, file.contents()).expect("Failed to create temp file");
}

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

    move_dir(&src_dir, &SRC_DIR);

    // we do this so things fs functions will be relative to our temp directory
    set_current_dir(cwd_dir).expect("Failed to set current directory to temp directory");
}
