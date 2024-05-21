local mod_event_loop = require("@luneweb/event_loop")
local mod_webview = require("@luneweb/webview")
local mod_window = require("@luneweb/window")
local fs = require("@lune/fs")

local webview_builder = mod_webview.new()
webview_builder:with_initialization_script(fs.readFile("../src/init.js"))

local window = mod_window.new()
local _webview = webview_builder:build(window)

mod_event_loop.subscribe(window.id, function(event)
	if event == "CloseRequested" then
		window:close()
	end
end)
