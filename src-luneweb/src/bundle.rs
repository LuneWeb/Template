use std::env::current_dir;

use include_dir::{include_dir, Dir};
use lune_std::context::GlobalsContextBuilder;

pub const SRC_DIR: Dir = include_dir!("src/");

pub fn bundle(ctx_builder: &mut GlobalsContextBuilder) {
    let cwd = current_dir().unwrap();

    for file in SRC_DIR.files() {
        ctx_builder.with_script(cwd.join("src").join(file.path()), file.contents().into())
    }
}
