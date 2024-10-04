local process = require("@lune/process")
local useDom = require("@luneweb/dom")
local task = require("@lune/task")
local fs = require("@lune/fs")

local window = WindowBuilder.new({
	dev = false,
})

local playlist: { string } = {}
local directories = {}
directories.home = if process.os == "windows" then process.env.HOMEPATH else nil
directories.music = `{directories.home}/Music`

assert(directories.home, "Home directory not found (might not be implemented for this os yet.)")
assert(AudioBuilder, "Audio is not available")

for _, name in fs.readDir(directories.music) do
	local path = `{directories.music}/{name}`

	if fs.isDir(path) then
		continue
	end

	table.insert(playlist, path)
end

print(`Playlist contains {#playlist} songs`)

local currentAudio: AudioSource?
local currentIndex = 0
local threads: { thread? } = {}

local function stopAudio()
	if currentAudio then
		currentAudio:stop()
	end
end

local function loadCurrentPlaylistAudio()
	assert(AudioBuilder)

	local content = fs.readFile(playlist[currentIndex])
	local audio = AudioBuilder.fromBuffer(buffer.fromstring(content))
	audio:play()

	stopAudio()
	currentAudio = audio

	return audio
end

useDom.connect(window, function(dom)
	for i, v in threads do
		assert(v)
		task.cancel(v)
		threads[i] = nil
	end

	stopAudio()
	currentIndex = 0

	local nextButton = dom:createElement("button")
	nextButton:setProp("innerHTML", "Next")
	nextButton:listen("click", function()
		currentIndex += 1

		if currentIndex >= #playlist then
			currentIndex = 1
		end

		loadCurrentPlaylistAudio()
	end)

	local prevButton = dom:createElement("button")
	prevButton:setProp("innerHTML", "Previous")
	prevButton:listen("click", function()
		currentIndex -= 1

		if currentIndex <= 0 then
			currentIndex = #playlist
		end

		loadCurrentPlaylistAudio()
	end)

	local progressBar = dom:createElement("progress")
	progressBar:setProp("max", 100)
	progressBar:setProp("value", 0)

	local function updateProgressBar()
		if currentAudio then
			local alpha = currentAudio.position / currentAudio.duration
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
