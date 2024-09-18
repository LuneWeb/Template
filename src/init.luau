local task = require("@lune/task")

local window = WindowBuilder.new({
	title = "Lune+Tauri",
	url = "http://localhost:5173",
})

print("Running luneweb", _VERSION)

task.spawn(window.message.listen, window.message, function(message)
	if message == "loaded" then
		print("Page loaded")
	end
end)
