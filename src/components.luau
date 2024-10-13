local jecs = require("@pkg/jecs/src")
local world = require("./world")

return {
	MusicState = world:component() :: jecs.Entity<{ source: AudioSource?, index: number }>,
	MusicPlaylist = world:component() :: jecs.Entity<{ location: string?, contents: { string } }>,
}
