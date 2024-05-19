# LuneWeb-template

> [!IMPORTANT]
> running and building an application requires you to have `cargo` installed
>
> so make sure to install `rustup`

---
> [!CAUTION]
> Make sure to keep all the files that are supposed to be accessed by your application in the `src` directory, since that's the only directory that gets bundled with the application

## Running your application

```shell
cargo run
```

## Building your application

```shell
cargo build --release
```

> [!NOTE]
> With the current version of lune-std, we have no control over how the global `require` function works and interacts with the filesystem, so we can't bundle all the scripts when the application is built, we instead make the application create a temp directory and dump all the scripts there.
