---@type string, AtlasNamespace
local _, ns = ...

-- English phrases are the keys. A translation lists the same keys with its own text, and the fallback keeps an
-- untranslated phrase readable instead of blank.
---@type table<string, string>
local L = {
	["Atlas Forever"] = "Atlas Forever",
	["%s: %d bookmarks"] = "%s: %d bookmarks",
	["%s: bookmarks are not loaded yet"] = "%s: bookmarks are not loaded yet",
	["Choose an instance"] = "Choose an instance",
	["Select a dungeon or raid to view its map."] = "Select a dungeon or raid to view its map.",
	["Coordinates unavailable"] = "Coordinates unavailable",
	["Bookmark"] = "Bookmark",
	["Remove bookmark"] = "Remove bookmark",
	["Set waypoint"] = "Set waypoint",
	["No instance map data is available for this selection."] = "No instance map data is available for this selection.",
	["No matching instances."] = "No matching instances.",
}

setmetatable(L, {
	__index = function(_, key)
		return key
	end,
})

ns.L = L
