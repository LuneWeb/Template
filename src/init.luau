local useDom = require("@luneweb/dom")
local task = require("@lune/task")

local world = require("./world")
local components = require("./components")
local locations = require("./locations")
local actions = require("./actions")

local MusicPlayer = world:entity()
world:set(MusicPlayer, components.MusicState, { source = nil, index = 0 })
world:set(MusicPlayer, components.MusicPlaylist, { contents = {}, location = locations.music })

local window = WindowBuilder.new({
	dev = false,
})

assert(AudioBuilder, "Audio is not available")

local threads: { thread? } = {}

useDom.connect(window, function(dom)
	for i, v in threads do
		assert(v)
		task.cancel(v)
		threads[i] = nil
	end

	actions.LoadMusic()

	local nextButton = dom:createElement("button")
	nextButton:setProp("innerHTML", "Next")
	nextButton:listen("click", function()
		local playlist = assert(world:get(MusicPlayer, components.MusicPlaylist))
		local state = assert(world:get(MusicPlayer, components.MusicState))

		state.index += 1

		if state.index >= #playlist.contents then
			state.index = 1
		end

		actions.LoadMusic()
	end)

	local prevButton = dom:createElement("button")
	prevButton:setProp("innerHTML", "Previous")
	prevButton:listen("click", function()
		local playlist = assert(world:get(MusicPlayer, components.MusicPlaylist))
		local state = assert(world:get(MusicPlayer, components.MusicState))

		state.index -= 1

		if state.index <= 0 then
			state.index = #playlist.contents
		end

		actions.LoadMusic()
	end)

	local progressBar = dom:createElement("progress")
	progressBar:setProp("max", 100)
	progressBar:setProp("value", 0)

	local function updateProgressBar()
		local state = assert(world:get(MusicPlayer, components.MusicState))

		if state.source then
			local alpha = state.source.position / state.source.duration
			progressBar:setProp("value", alpha * 100)
		end
	end

	table.insert(
		threads,
		task.spawn(function()
			while true do
				task.wait(0.16)

				updateProgressBar()
			end
		end)
	)

	assert(dom.body, "body is not available")
	dom.body:appendChild(prevButton)
	dom.body:appendChild(nextButton)
	dom.body:appendChild(progressBar)
end)

print("Running luneweb", _VERSION)

actions.LoadPlaylists()
