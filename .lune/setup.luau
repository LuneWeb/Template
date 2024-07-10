local process = require("@lune/process")
local fs = require("@lune/fs")

local function getHome()
	local raw = process.spawn("echo", { "$HOME" }, {
		shell = true,
	}).stdout

	return string.match(raw, "%s*([^%s]*)%s*")
end

--[[

for some reason this option `luau-lsp.types.definitionFiles`
doesn't work with a path that starts with `~`

so we'll have to copy the typedef file into our project to use it

]]
local function moveDefinitionFiles()
	local target = `.luneweb/.type_defs-0.3.0-pre2.d.luau`
	local file = `{getHome()}/{target}`

	if not fs.isDir(".luneweb") then
		fs.writeDir(".luneweb")
	end

	fs.copy(file, target, true)
end

moveDefinitionFiles()
