local fs = require("@lune/fs")
local world = require("./world")
local components = require("./components")

local function LoadPlaylists()
	for _, musicPlaylist, musicState in world:query(components.MusicPlaylist, components.MusicState):iter() do
		if musicState.source then
			musicState.source:stop()
			musicState.source = nil
		end

		table.clear(musicPlaylist.contents)
		musicState.index = 0

		if musicPlaylist.location == nil then
			continue
		end

		for _, name in fs.readDir(musicPlaylist.location) do
			local path = `{musicPlaylist.location}/{name}`

			if fs.isDir(path) then
				continue
			end

			table.insert(musicPlaylist.contents, fs.readFile(path))
		end

		print(`Playlist contains {#musicPlaylist.contents} songs`)
	end
end

local function LoadMusic()
	assert(AudioBuilder, "AudioBuilder is unavailable")

	for _, musicPlaylist, musicState in world:query(components.MusicPlaylist, components.MusicState):iter() do
		if musicState.source then
			musicState.source:stop()
			musicState.source = nil
		end

		if musicState.index == 0 then
			continue
		end

		local musicBuffer = buffer.fromstring(musicPlaylist.contents[musicState.index])
		local audio = AudioBuilder.fromBuffer(musicBuffer)

		audio:play()

		musicState.source = audio
	end
end

return {
	LoadPlaylists = LoadPlaylists,
	LoadMusic = LoadMusic,
}
