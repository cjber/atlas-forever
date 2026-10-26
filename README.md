<p align="center"><img src="media/icon-400.png" width="96" alt="Atlas Forever icon"></p>

<h1 align="center">Atlas Forever</h1>

<p align="center">
The instance index for WoW: Forever: every dungeon and raid the client knows, its floors and its way in.<br>
<a href="https://github.com/cjber/atlas-forever/actions/workflows/ci.yml"><img src="https://github.com/cjber/atlas-forever/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
<a href="https://github.com/cjber/atlas-forever/releases/latest"><img src="https://img.shields.io/github/v/release/cjber/atlas-forever" alt="Latest release"></a>
<a href="https://ko-fi.com/cjber59408"><img src="https://img.shields.io/badge/Ko--fi-tip-ff5e5b?logo=ko-fi&logoColor=white" alt="Ko-fi"></a>
</p>

Atlas Forever opens an instance browser with a searchable list, a map view, floor choices when the client provides them, and account-wide bookmarks. The waypoint control appears when entrance coordinates are available.

<p align="center"><img src="docs/screenshots/window.png" alt="Atlas Forever instance browser mock" width="800"></p>

The mock uses Blizzard's window art, font and instance names. This client build has no instance map art in its `UiMap` data, so the empty map area is shown plainly.

## What is here

- **The instance browser.** Search the client-reported list, open an instance and choose a floor when it has more than one map.
- **Bookmarks and waypoints.** Save favourite instances per account. Set a waypoint when the client data includes an entrance and the map accepts one.
- **An API for other Forever addons.** `AtlasForever.API` (version 1.1) returns a filtered instance list, an entry by map ID, and opens an entry in the window.

## Install

Copy the `AtlasForever` folder into `_classic_beta_/Interface/AddOns/`, so you end up with `AddOns/AtlasForever/AtlasForever.toc`. After an update, `/reload`.

The addon targets the WoW: Forever client, Interface 16001, and needs nothing else installed.

## Usage

| Command | What it does |
|---|---|
| `/atlas`, `/atlasforever` | Open the instance browser |

## What it never does

Atlas Forever is the map index. It does not plan a route or estimate travel time (that is [Shortest Path](../shortest-path-forever)), does not choose quests (that is [Adventure Guide](../adventure-guide-forever)), does not own pins for a place type another addon registers, and does not show loot tables. `forever-handoff/boundaries.md` in [cjber/forever-core](https://github.com/cjber/forever-core) has the suite's ownership rules.

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

## Development

Specs run on LuaJIT against a mock client (`tests/wow_mock.lua`), so they need no game client. Render the README mock with the shared renderer:

```sh
for spec in tests/*_spec.lua; do luajit "$spec" || exit 1; done
python3 tools/screenshots.py
```

`Core/Model.lua` is pure and its specs carry no client at all. [AGENTS.md](AGENTS.md) has the full gate, the layout and the rules this repository is held to.

## Credits

Made by cjber. Blizzard Entertainment for the game and its map data. The WoW: Forever project for the client it is written for.

World of Warcraft is a trademark of Blizzard Entertainment, Inc. This addon is not affiliated with or endorsed by Blizzard Entertainment.

## Licence

GPL-3.0-or-later. See [LICENSE](LICENSE).

Made by Cillian Berragan · [cillian.dev](https://cillian.dev) · [GitHub](https://github.com/cjber) · [Twitter](https://twitter.com/cjberragan)

Built with AI assistance.
