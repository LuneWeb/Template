local scope = require("scope")

type Scope = typeof(scope(nil :: any))

return function(scope: Scope)
	-- click counter
	table.insert(
		scope.connections,
		scope.webview:subscribe("Clicked", function(clicks)
			print(clicks)
		end)
	)

	scope:button("Hello, World!")
	scope:button("Click Me!", "Clicked")
end
