-- LIBRARIES
local mod_event_loop = require("@luneweb/event_loop")
local mod_window = require("@luneweb/window")
local mod_webview = require("@luneweb/webview")
local fs = require("@lune/fs")

-- BUILDERS
local webview_builder = mod_webview.new()
webview_builder:with_initialization_script(fs.readFile("../src/init.js"))

-- VARIABLES
local window = mod_window.new()
local webview = webview_builder:build(window)
local connections: { mod_webview.Connection } = {}

-- VARIABLES (DEV-ONLY)
local _id = 0
local _pending = {}

-- FUNCTIONS
local function button(text: string)
	local button = fs.readFile("../src/button.js"):gsub("$TEXT", text):gsub("element", "element" .. _id)
	_id += 1

	table.insert(_pending, button)
end

local function main()
	table.insert(
		connections,
		webview:subscribe("loaded", function(value)
			_id = 0

			button("Hello, World!")
			button("Hello, World!")
			button("Hello, World!")
			button("Hello, World!")
			button("Hello, World!")

			local raw = table.concat(_pending, ";")
			webview:evaluate_script(raw)
			table.clear(_pending)
		end)
	)
end

table.insert(
	connections,
	mod_event_loop.subscribe(window.id, function(event)
		if event == "CloseRequested" then
			window:close()

			for _, connection in connections do
				connection:disconnect()
			end
		end
	end)
)

mod_event_loop.new()

main()
