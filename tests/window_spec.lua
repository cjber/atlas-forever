-- The browser's one-time construction, visibility, selection, bookmark and search contract against inert client frames.
local Mock = dofile("tests/wow_mock.lua")
local ns = { L = setmetatable({}, {
	__index = function(_, phrase)
		return phrase
	end,
}) }
ns.db = { bookmarks = {}, settings = { travelButton = true } }
ns.Instances = {
	{ id = 1, mapID = 10, name = "Blackfathom Deeps", mapType = "party", continent = "Kalimdor" },
	{ id = 2, mapID = 20, name = "Molten Core", mapType = "raid", continent = "Eastern Kingdoms" },
}
local ready
ns.OnReady = function(callback)
	ready = callback
end
local harness = Mock.Harness({ files = {}, ns = ns })
harness.Load("Core/Model.lua")
harness.env.C_Map.GetMapInfo = function(mapID)
	return { mapID = mapID }
end
harness.env.C_Map.GetMapChildrenInfo = function(mapID)
	if mapID == 10 then
		return { { mapID = 101, name = "Upper" }, { mapID = 102, name = "Lower" } }
	end
	return {}
end
harness.Load("UI/Window.lua")
ready()

local checks = 0
local function equal(actual, expected, label)
	checks = checks + 1
	if actual ~= expected then
		error(("%s: expected %s, got %s"):format(label, tostring(expected), tostring(actual)), 2)
	end
end
local function check(value, label)
	checks = checks + 1
	assert(value, label)
end

local window = ns.Window
check(window ~= nil and window:IsShown() == false, "ready builds a hidden window")
local count = #Mock.frames
check(ns.OpenInstance(10), "opening a known instance succeeds")
equal(ns.Window, window, "open reuses the built window")
equal(#Mock.frames, count, "open does not build another window")
equal(window:IsShown(), true, "open shows the window")
equal(window.MapTitle:GetText(), "Blackfathom Deeps", "selection sets the pane header")
equal(window.Floor:IsShown(), true, "multiple floors show the floor dropdown")
window.Floor._initialize(window.Floor, 1)
equal(#Mock.dropdownButtons, 2, "the selected instance populates its floor list")
equal(Mock.dropdownButtons[1].info.text, "Upper", "the first floor is listed")
equal(Mock.dropdownButtons[2].info.text, "Lower", "the second floor is listed")
check(window.ListContent.rows[1].SelectedHighlight:IsShown(), "the selected instance row is highlighted")

window.Bookmark._scripts.OnClick(window.Bookmark)
equal(#ns.db.bookmarks, 1, "bookmark adds the selected entry")
equal(ns.db.bookmarks[1].mapID, 10, "bookmark stores the selected map")
equal(window.Bookmark:GetText(), "Remove bookmark", "bookmark action changes to remove")
window.Bookmark._scripts.OnClick(window.Bookmark)
equal(#ns.db.bookmarks, 0, "bookmark toggle removes the entry")
equal(window.Bookmark:GetText(), "Bookmark", "bookmark action changes back")

window.Search:SetText("Molten")
window.Search._scripts.OnTextChanged(window.Search)
equal(window.ListContent.rows[1].entry.name, "Molten Core", "search narrows the visible list")
equal(window.ListContent.rows[2]:IsShown(), false, "search hides rows outside the match")
window:Hide()
equal(window:IsShown(), false, "close hides the window")
check(ns.OpenInstance(20), "a later open still succeeds")
equal(window:IsShown(), true, "the same window can be reopened")
equal(window.MapTitle:GetText(), "Molten Core", "reopening selects the requested instance")

print(("window_spec: %d checks passed"):format(checks))
