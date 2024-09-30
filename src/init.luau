local window = WindowBuilder.new({})
local useDom = require("@luneweb/dom")

print("Running luneweb", _VERSION)

assert(AudioBuilder, "Audio is not available")

useDom.connect(window, function(dom)
	print("Dom Loaded")
end)
