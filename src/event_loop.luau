local _event_loop = require("@luneweb/event_loop")
local _window = require("@luneweb/window")

local lib = {
	window = _window,
	event_loop = _event_loop,
}

return function(connections: { _event_loop.Connection }, cleanup: () -> (), window: _window.Window)
	-- Building webview
	table.insert(
		connections,
		lib.event_loop.subscribe(window.id, function(event)
			if event == "CloseRequested" then
				cleanup()

				for _, connection in connections do
					connection:disconnect()
				end

				window:close()
			end
		end)
	)

	lib.event_loop.new()
end
