use luneweb::{init, patch_lua};
use std::{path::PathBuf, rc::Rc};

mod temp;

#[cfg(not(debug_assertions))]
mod console;

#[tokio::main]
async fn main() -> mlua::Result<()> {
    let lua = Rc::new(mlua::Lua::new());
    patch_lua(&lua);
    temp::build_dir();

    #[cfg(not(debug_assertions))]
    console::hide_console();

    let src = PathBuf::from("../src/init.luau");
    let result = init(&lua, &src).await;

    match result {
        Ok(sched) => sched.run().await,
        Err(err) => println!("{err:?}"),
    }

    Ok(())
}
