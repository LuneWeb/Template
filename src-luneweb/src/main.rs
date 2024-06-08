use bundle::SRC_DIR;
use lune_std::context::GlobalsContextBuilder;
use luneweb::lua::{inject_globals, patch_lua};
use mlua::ExternalResult;
use mlua_luau_scheduler::Scheduler;
use std::{env::current_dir, rc::Rc};

mod bundle;

#[cfg(not(debug_assertions))]
mod console;

#[tokio::main]
async fn main() -> mlua::Result<()> {
    let lua = Rc::new(mlua::Lua::new());
    let mut builder = GlobalsContextBuilder::default();

    patch_lua(&lua);
    lua.sandbox(true).into_lua_err()?;

    inject_globals(&mut builder)?;
    bundle::bundle(&mut builder)?;
    lune_std::inject_libraries(&mut builder)?;
    lune_std::inject_globals(&lua, &builder.build())?;

    #[cfg(not(debug_assertions))]
    console::hide_console();

    let sched = Scheduler::new(&lua);
    let file = SRC_DIR.get_file("init.luau").unwrap();
    let src = file.contents_utf8().unwrap();

    let main = lua.load(src).set_name(
        current_dir()
            .unwrap()
            .join("../src/")
            .join(file.path())
            .to_string_lossy(),
    );
    sched.push_thread_back(main, ())?;
    sched.run().await;

    Ok(())
}
