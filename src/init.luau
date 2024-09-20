local window = WindowBuilder.new({
	title = "Lune+Tauri",
})

print("Running luneweb", _VERSION)

window.message:listen(function(message)
	if message == "loaded" then
		print("Page loaded")
	end
end)
