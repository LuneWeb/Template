# LuneWeb-template

> [!IMPORTANT]
> running and building an application requires you to have `cargo` installed
>
> so make sure to install `rustup`

---
> [!CAUTION]
> Make sure to keep all the files that are supposed to be accessed by your application in the `src` directory, since that's the only directory that gets bundled with the application

---
## Cross-Platform

### Arch Linux / Manjaro:
`sudo pacman -S gtk3`

`sudo pacman -S webkit2gtk-4.1`

### Debian / Ubuntu:
`sudo apt install libgtk-3-dev`

`sudo apt install libwebkit2gtk-4.1-dev`

### Fedora:
`sudo dnf install gtk3-devel webkit2gtk4.1-devel`

### Windows:
WebView2 provided by Microsoft Edge Chromium is used. So LuneWeb supports Windows 7, 8, 10 and 11.

### (NOT TESTED) macOS:
WebKit is native on macOS so everything should be fine.

### Android / IOS:
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

> [!NOTE]
> With the current version of lune-std, we have no control over how the global `require` function works and interacts with the filesystem, so we can't bundle all the scripts when the application is built, we instead make the application create a temp directory and dump all the scripts there.
