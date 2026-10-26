Atlas Forever is the map index for WoW: Forever: every dungeon and raid the client knows, its floors and its way in, with the places you name kept as bookmarks that set the game's own waypoint.

It is not playable yet. This repository carries the instance index, the saved bookmark state and the API other Forever addons read. The window, the client map reading and the waypoint button are still to come.

## What is here

- **The instance index.** Filter and find entries by continent, map type, level range and a name. A level range is shown only when the client reports it.
- **Bookmark state.** Bookmarks are saved per account as plain data, with the most recently viewed places remembered separately.
- **An API for other Forever addons.** `AtlasForever.API` answers a filtered instance list, one instance by map ID, and asks the window to open one.

<!-- forever-family:start -->

## The Forever addons

Each one works on its own, and they work together when you install more than one.

| Addon | What it does |
|---|---|
| [Shortest Path Forever](https://www.curseforge.com/wow/addons/shortest-path-forever) | Plans journeys on foot, by air, by sea and through portals, with directions in the tracker. |
| [Adventure Guide Forever](https://www.curseforge.com/wow/addons/adventure-guide-forever) | Suggests quests for your level and routes you from one to the next. |
| [SkillUp Forever](https://www.curseforge.com/wow/addons/skillup-forever) | Shows skill-up chances, recipe costs and levelling routes in the Professions window. |
| [Legacy Forever](https://www.curseforge.com/wow/addons/legacy-forever) | Shows your unfinished Legacy challenges on the world map and tracks the ones you choose. |
| [Tweaks Forever](https://www.curseforge.com/wow/addons/tweaks-forever) | Adds quest automation, rare alerts and merchant options to the game's settings. |

<!-- forever-family:end -->

## Usage

`/atlas` or `/atlasforever` prints the bookmark state.

Atlas Forever never plans a route or estimates travel time, never chooses quests and never owns another addon's map pins.

Source: [github.com/cjber/atlas-forever](https://github.com/cjber/atlas-forever), GPL-3.0-or-later.

The addon is free. If it saves you time, you can [buy me a coffee on Ko-fi](https://ko-fi.com/cjber59408).

Built with AI assistance.
