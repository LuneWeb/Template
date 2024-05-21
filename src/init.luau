-- Types
local _event_loop = require("@luneweb/event_loop")
local _webview = require("@luneweb/webview")
local _window = require("@luneweb/window")

-- Modules
local lib = {
	event_loop = _event_loop,
	webview = _webview,
	window = _window,

	event_loop_builder = require("event_loop"),
	webview_builder = require("webview"),
	ui = require("app/ui"),
	scope = require("app/scope"),

	fs = require("@lune/fs"),
}

local window = lib.window.new()
local webview = lib.webview_builder(window)
local current_scope

webview:subscribe("load", function(_)
	-- clean previous scope
	if current_scope then
		current_scope:clean()
	end

	-- create new scope
	current_scope = lib.scope(webview)

	-- recreate ui using the new scope
	lib.ui(current_scope)
end)

lib.event_loop_builder(function()
	if current_scope then
		current_scope:clean()
	end
end, window)
