---@type string, AtlasNamespace
local _, ns = ...

local L = ns.L
local WINDOW_WIDTH, WINDOW_HEIGHT = 920, 590
local ROW_HEIGHT = 30

local function text(parent, font, phrase)
	local value = parent:CreateFontString(nil, "ARTWORK", font)
	value:SetText(L[phrase])
	return value
end

local function isBookmarked(mapID)
	for _, bookmark in ipairs(ns.db.bookmarks or {}) do
		if bookmark.mapID == mapID then
			return true
		end
	end
	return false
end

local function toggleBookmark(entry)
	local bookmarks = ns.db.bookmarks
	for index, bookmark in ipairs(bookmarks) do
		if bookmark.mapID == entry.mapID then
			table.remove(bookmarks, index)
			return
		end
	end
	bookmarks[#bookmarks + 1] = { mapID = entry.mapID, name = entry.name }
end

local function makeWindow()
	if ns.Window then
		return ns.Window
	end
	local window = CreateFrame("Frame", "AtlasForeverWindow", UIParent, "PortraitFrameTemplate")
	window.Selected = false
	window:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
	window:SetPoint("CENTER")
	window:SetMovable(true)
	window:EnableMouse(true)
	window:RegisterForDrag("LeftButton")
	window:SetScript("OnDragStart", window.StartMoving)
	window:SetScript("OnDragStop", window.StopMovingOrSizing)
	window:SetClampedToScreen(true)
	window:Hide()
	window.TitleText:SetText(L["Atlas Forever"])
	window.portrait:SetTexture("Interface\\AddOns\\AtlasForever\\media\\Icon")
	table.insert(UISpecialFrames, "AtlasForeverWindow")

	local search = CreateFrame("EditBox", nil, window, "SearchBoxTemplate")
	search:SetSize(250, 24)
	search:SetPoint("TOPLEFT", 18, -72)
	search:SetAutoFocus(false)
	search:SetScript("OnTextChanged", function()
		window:RefreshList()
	end)
	window.Search = search

	local list = CreateFrame("ScrollFrame", nil, window, "ScrollFrameTemplate")
	list:SetPoint("TOPLEFT", 18, -108)
	list:SetSize(270, 420)
	local content = CreateFrame("Frame", nil, list)
	content:SetSize(250, 1)
	list:SetScrollChild(content)
	window.ListContent = content
	content.rows = {}
	local noResults = text(content, "GameFontDisableSmall", "No matching instances.")
	noResults:SetPoint("TOPLEFT", 4, 0)
	window.NoResults = noResults
	local divider = window:CreateTexture(nil, "BORDER")
	divider:SetColorTexture(0, 0, 0, 0.55)
	divider:SetPoint("TOPLEFT", list, "TOPRIGHT", 9, 0)
	divider:SetPoint("BOTTOMLEFT", list, "BOTTOMRIGHT", 9, 0)
	divider:SetWidth(1)
	window.Divider = divider

	local mapTitle = text(window, "GameFontNormalLarge", "Choose an instance")
	mapTitle:SetPoint("TOPLEFT", list, "TOPRIGHT", 28, -2)
	window.MapTitle = mapTitle
	local breadcrumb = text(window, "GameFontHighlightSmall", "Select a dungeon or raid to view its map.")
	breadcrumb:SetPoint("TOPLEFT", mapTitle, "BOTTOMLEFT", 0, -8)
	window.Breadcrumb = breadcrumb

	local map = CreateFrame("Frame", nil, window, "MapCanvasFrameTemplate")
	map:SetPoint("TOPLEFT", breadcrumb, "BOTTOMLEFT", 0, -12)
	map:SetSize(570, 365)
	window.Map = map
	local mapBacking = map:CreateTexture(nil, "BACKGROUND")
	mapBacking:SetColorTexture(0.025, 0.035, 0.05, 0.82)
	mapBacking:SetPoint("TOPLEFT", -4, 4)
	mapBacking:SetPoint("BOTTOMRIGHT", 4, -4)
	window.MapBacking = mapBacking

	local floor = CreateFrame("Frame", nil, window, "UIDropDownMenuTemplate")
	floor:SetPoint("TOPLEFT", map, "BOTTOMLEFT", -16, -2)
	window.Floor = floor

	local coords = text(window, "GameFontHighlight", "Coordinates unavailable")
	coords:SetPoint("LEFT", floor, "RIGHT", 10, 2)
	window.Coordinates = coords

	local actionBar = CreateFrame("Frame", nil, window)
	actionBar:SetSize(570, 44)
	actionBar:SetPoint("BOTTOMRIGHT", -24, 20)
	local actionBacking = actionBar:CreateTexture(nil, "BACKGROUND")
	actionBacking:SetColorTexture(0.02, 0.025, 0.035, 0.9)
	actionBacking:SetAllPoints()
	window.ActionBar = actionBar
	local bookmark = CreateFrame("Button", nil, actionBar, "UIPanelButtonTemplate")
	bookmark:SetSize(155, 24)
	bookmark:SetPoint("RIGHT", actionBar, "RIGHT", -12, 0)
	bookmark:SetText(L["Bookmark"])
	bookmark:SetScript("OnClick", function()
		if window.Selected then
			toggleBookmark(window.Selected)
			bookmark:SetText(isBookmarked(window.Selected.mapID) and L["Remove bookmark"] or L["Bookmark"])
			window:RefreshList()
		end
	end)
	window.Bookmark = bookmark

	local waypoint = CreateFrame("Button", nil, actionBar, "UIPanelButtonTemplate")
	waypoint:SetSize(155, 24)
	waypoint:SetPoint("RIGHT", bookmark, "LEFT", -8, 0)
	waypoint:SetText(L["Set waypoint"])
	waypoint:SetScript("OnClick", function()
		local entry = window.Selected
		local point = entry and entry.entrances and entry.entrances[1]
		if not point or InCombatLockdown() or type(C_Map.CanSetUserWaypointOnMap) ~= "function" then
			return
		end
		if type(C_Map.SetUserWaypoint) ~= "function" or not C_Map.CanSetUserWaypointOnMap(point.map) then
			return
		end
		C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(point.map, point.x, point.y))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			C_SuperTrack.SetSuperTrackedUserWaypoint(true)
		end
	end)
	window.Waypoint = waypoint

	local empty = text(window, "GameFontDisableSmall", "No instance map data is available for this selection.")
	empty:SetPoint("BOTTOMLEFT", map, "BOTTOMLEFT", 0, -34)
	window.Empty = empty

	function window:Select(entry)
		self.Selected = entry
		self.MapTitle:SetText(entry.name)
		self.Breadcrumb:SetText(entry.continent or entry.mapType or "")
		self.Map:SetMapID(entry.mapID)
		local point = entry.entrances and entry.entrances[1]
		self.Coordinates:SetText(
			point and string.format("%.1f, %.1f", point.x * 100, point.y * 100) or L["Coordinates unavailable"]
		)
		self.Empty:SetShown(not C_Map.GetMapInfo(entry.mapID))
		self.Floor:Hide()
		self.Bookmark:SetText(isBookmarked(entry.mapID) and L["Remove bookmark"] or L["Bookmark"])
		self.Waypoint:SetShown(entry.entrances ~= nil and ns.db.settings.travelButton == true)
		local floors = C_Map.GetMapChildrenInfo(entry.mapID, nil, true) or {}
		if #floors > 1 then
			UIDropDownMenu_Initialize(self.Floor, function(_, level)
				for _, child in ipairs(floors) do
					local info = UIDropDownMenu_CreateInfo()
					info.text = child.name
					info.value = child.mapID
					info.func = function()
						self.Map:SetMapID(child.mapID)
						UIDropDownMenu_SetSelectedValue(self.Floor, child.mapID)
					end
					UIDropDownMenu_AddButton(info, level)
				end
			end)
			UIDropDownMenu_SetWidth(self.Floor, 170)
			UIDropDownMenu_SetSelectedValue(self.Floor, floors[1].mapID)
			self.Map:SetMapID(floors[1].mapID)
			self.Floor:Show()
		end
		self:RefreshList()
	end

	function window:RefreshList()
		local entries = ns.Model.Filter(ns.Instances, { query = self.Search:GetText() })
		self.NoResults:SetShown(#entries == 0)
		for _, row in ipairs(self.ListContent.rows or {}) do
			row:Hide()
		end
		self.ListContent.rows = self.ListContent.rows or {}
		for index, entry in ipairs(entries) do
			local row = self.ListContent.rows[index]
			if not row then
				row = CreateFrame("Button", nil, self.ListContent, "MapCanvasZoomInButtonTemplate")
				row:SetSize(244, ROW_HEIGHT)
				row.Label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
				row.Label:SetPoint("LEFT", 6, 0)
				row.SelectedHighlight = row:CreateTexture(nil, "BACKGROUND")
				row.SelectedHighlight:SetColorTexture(0.12, 0.38, 0.62, 0.48)
				row.SelectedHighlight:SetPoint("TOPLEFT", 0, -1)
				row.SelectedHighlight:SetPoint("BOTTOMRIGHT", 0, 1)
				row:SetScript("OnClick", function(button)
					window:Select(button.entry)
				end)
				self.ListContent.rows[index] = row
			end
			row.entry = entry
			row.SelectedHighlight:SetShown(self.Selected and self.Selected.mapID == entry.mapID or false)
			row:SetPoint("TOPLEFT", 0, -(index - 1) * ROW_HEIGHT)
			local range = ns.Model.LevelRange(entry)
			row.Label:SetText(
				(isBookmarked(entry.mapID) and "|cffffd200★|r " or "")
					.. entry.name
					.. (range and "  " .. range or "")
			)
			row:Show()
		end
		self.ListContent:SetHeight(math.max(#entries * ROW_HEIGHT, 1))
	end

	ns.Window = window
	return window
end

function ns.OpenInstance(mapID)
	local entry = ns.Model.Find(ns.Instances, mapID)
	if not entry then
		return false
	end
	local window = makeWindow()
	window:Select(entry)
	window:Show()
	return true
end

ns.OnReady(function()
	local window = makeWindow()
	window:RefreshList()
end)

SLASH_ATLASFOREVER1 = "/atlas"
SLASH_ATLASFOREVER2 = "/atlasforever"
SlashCmdList["ATLASFOREVER"] = function()
	if not ns.ready or not ns.Instances then
		return
	end
	local window = makeWindow()
	window:RefreshList()
	window:Show()
end
