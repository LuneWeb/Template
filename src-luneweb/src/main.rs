use lune_std::context::GlobalsContextBuilder;
use luneweb::lua::{inject_globals, patch_lua};
use mlua::ExternalResult;
use mlua_luau_scheduler::Scheduler;
use std::{fs, path::PathBuf, rc::Rc};

mod temp;

#[cfg(not(debug_assertions))]
mod console;

#[tokio::main]
async fn main() -> mlua::Result<()> {
    let lua = Rc::new(mlua::Lua::new());
    let mut builder = GlobalsContextBuilder::default();

    lua.sandbox(true).into_lua_err()?;

    patch_lua(&lua);
    inject_globals(&mut builder)?;
    lune_std::inject_globals(&lua, builder)?;

    temp::build_dir();

    #[cfg(not(debug_assertions))]
    console::hide_console();

    let sched = Scheduler::new(&lua);
    let path = PathBuf::from("../src/init.luau");
    let src = fs::read_to_string(&path)?;

    let main = lua.load(src).set_name(path.to_string_lossy().to_string());
    sched.push_thread_back(main, ())?;
    sched.run().await;

    Ok(())
}
