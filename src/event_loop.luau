local _event_loop = require("@luneweb/event_loop")
local _window = require("@luneweb/window")

local lib = {
	window = _window,
	event_loop = _event_loop,
}

return function(cleanup: () -> (), window: _window.Window)
	-- Building webview
	lib.event_loop.subscribe(window.id, function(event)
		if event == "CloseRequested" then
			cleanup()

			-- when all the available windows in the app are closed
			-- the event loop disconnects automatically
			window:close()
		end
	end)
end
