local _webview = require("@luneweb/webview")
local _window = require("@luneweb/window")

local lib = {
	webview = _webview,
	window = _window,
	fs = require("@lune/fs"),
}

return function(window: _window.Window)
	-- Building webview
	local builder = lib.webview.new()
	builder:with_initialization_script(lib.fs.readFile("../src/init.js"))

	builder:with_custom_protocol("app", function(request)
		return {
			body = '"Hello, World!"',
			headers = {
				["Access-Control-Allow-Origin"] = "*",
			},
		}
	end)

	return builder:build(window)
end
