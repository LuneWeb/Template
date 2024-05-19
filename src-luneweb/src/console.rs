pub fn hide_console() {
    #[cfg(windows)]
    {
        use winapi::um::*;

        let window = unsafe { wincon::GetConsoleWindow() };

        if !window.is_null() {
            unsafe {
                winuser::ShowWindow(window, winuser::SW_HIDE);
                wincon::FreeConsole();
            }
        }
    }
}
