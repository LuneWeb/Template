local _webview = require("@luneweb/webview")
local _serde = require("@lune/serde")

local lib = {
	serde = _serde,
}

local function new(webview: _webview.WebView)
	local scope = {}

	--[=[
		Each element will append this number to the end of their variable name

		e.g. element0, element1, element, etc...
	]=]
	scope.reserved_id = 0
	scope.webview = webview
	scope.connections = {} :: { _webview.Connection }

	--[=[
		Clean the scope
	]=]
	function scope:clean()
		for _, connection in scope.connections do
			connection:disconnect()
		end
	end

	--[=[
		Create a simple button

		if the 'channel' parameter is provided,
		a click counter will be setup for the button
		and a number will be sent to the ipc channel with every click
	]=]
	function scope:button(text: string, channel: string?)
		local ident = `element{scope.reserved_id}`

		scope.reserved_id += 1

		local script = {
			`let {ident} = document.createElement('button')`,
			`{ident}.innerHTML = {lib.serde.encode("json", text)}`,
			`{ident}.style.width = '250px'`,
			`{ident}.style.height = '50px'`,
			`document.body.appendChild({ident})`,
		}

		if channel then
			local counter_ident = `{ident}_counter`
			local inner = {
				`let {counter_ident} = 0`,
				`{ident}.onclick = function() \{`,
				`	{counter_ident} += 1`,
				`	window.luneweb.postMessage({lib.serde.encode("json", channel)}, {counter_ident})`,
				`}`,
			}

			for _, line in inner do
				table.insert(script, line)
			end
		end

		scope.webview:evaluate_script(table.concat(script, ";"))
	end

	return scope
end

return new
