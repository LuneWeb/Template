use std::env::current_dir;

use include_dir::{include_dir, Dir};
use lune_std::context::{GlobalsContextBuilder, LuneModuleCreator};

pub const SRC_DIR: Dir = include_dir!("src/");
pub const ASSETS_DIR: Dir = include_dir!("assets/");

pub fn bundle(ctx_builder: &mut GlobalsContextBuilder) -> mlua::Result<()> {
    let cwd = current_dir().unwrap();

    for file in SRC_DIR.files() {
        ctx_builder.with_script(cwd.join("src").join(file.path()), file.contents().into())
    }

    for file in ASSETS_DIR.files() {
        println!("{}", file.path().display());
    }

    ctx_builder.with_alias("bundler", move |modules| {
        modules.insert(
            "assets",
            LuneModuleCreator::LuaTable(|lua| {
                let t = lua.create_table()?;

                t.set(
                    "readFile",
                    lua.create_function(|_, path: String| {
                        println!("{path}");
                        if let Some(file) = ASSETS_DIR.get_file(&path) {
                            Ok(Some(String::from_utf8_lossy(file.contents())))
                        } else {
                            Ok(None)
                        }
                    })?,
                )?;

                t.set_readonly(true);
                Ok(t)
            }),
        );

        Ok(())
    })
}
