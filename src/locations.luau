local process = require("@lune/process")

local locations = {}

locations.home = assert(
	if process.os == "windows" then process.env.HOMEPATH else nil,
	"Home directory not found (might not be implemented for this os yet.)"
)

locations.music = `{locations.home}/Music`

return locations
