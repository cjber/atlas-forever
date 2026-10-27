---@type string, AtlasNamespace
local _, ns = ...

-- Build the browser index from maps the client reports. Classic clients do not always ship map
-- art for these entries, but the hierarchy can still report their names and map IDs.
---@return AtlasInstance[]
function ns.BuildInstances()
	local entries = {}
	if not C_Map or type(C_Map.GetMapChildrenInfo) ~= "function" or not Enum or not Enum.UIMapType then
		return entries
	end

	local dungeonType = Enum.UIMapType.Dungeon
	if type(dungeonType) ~= "number" then
		return entries
	end

	local maps = C_Map.GetMapChildrenInfo(946, dungeonType, true) or {}
	for _, map in ipairs(maps) do
		if type(map.mapID) == "number" and type(map.name) == "string" and map.name ~= "" then
			local parent = type(map.parentMapID) == "number"
					and type(C_Map.GetMapInfo) == "function"
					and C_Map.GetMapInfo(map.parentMapID)
				or nil
			entries[#entries + 1] = {
				id = map.mapID,
				name = map.name,
				mapID = map.mapID,
				mapType = "dungeon",
				continent = parent and parent.name or "",
			}
		end
	end

	return ns.Model.Filter(entries)
end

return ns.BuildInstances
