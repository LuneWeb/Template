local window = WindowBuilder.new({
	title = "Lune+Tauri",
	url = "http://localhost:5173",
})

print("Running luneweb", _VERSION)

window.message:listen(function(message)
	if message == "loaded" then
		print("Page loaded")
	end
end)
