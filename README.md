# LuneWeb-template

This repo will not always be up-to-date with the latest version of lune-std and luneweb-rs, so if You're looking for the most up-to-date examples, You shall read the examples in the [luneweb-rs repo](https://github.com/LuneWeb/LuneWeb-rs/tree/main/examples)

---

> [!NOTE]
> the `src` directory is for luau scripts
>
> and the `assets` directory is for files you want to access in your scripts using `require("@bundler/assets").readFile('<fileName>')`
>
> this is because of how the current bundler in `src-luneweb/src/bundle.rs` works

## Cross-Platform

### Arch Linux / Manjaro

`sudo pacman -S gtk3`

`sudo pacman -S webkit2gtk-4.1`

### Debian / Ubuntu

`sudo apt install libgtk-3-dev`

`sudo apt install libwebkit2gtk-4.1-dev`

### Fedora

`sudo dnf install gtk3-devel webkit2gtk4.1-devel`

### Windows

WebView2 provided by Microsoft Edge Chromium is used. So LuneWeb supports Windows 7, 8, 10 and 11.

### (NOT TESTED) macOS

WebKit is native on macOS so everything should be fine.

### Android / IOS

Not implemented yet.

---

## Running your application

```shell
cargo run
```

## Building your application

```shell
cargo build --release
```
