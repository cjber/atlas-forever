<p align="center"><img src="media/icon-400.png" width="96" alt="Atlas Forever icon"></p>

<h1 align="center">Atlas Forever</h1>

<p align="center">
The instance index for WoW: Forever: every dungeon and raid the client knows, its floors and its way in.<br>
<a href="https://github.com/cjber/atlas-forever/actions/workflows/ci.yml"><img src="https://github.com/cjber/atlas-forever/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
<a href="https://github.com/cjber/atlas-forever/releases/latest"><img src="https://img.shields.io/github/v/release/cjber/atlas-forever" alt="Latest release"></a>
<a href="https://ko-fi.com/cjber59408"><img src="https://img.shields.io/badge/Ko--fi-tip-ff5e5b?logo=ko-fi&logoColor=white" alt="Ko-fi"></a>
</p>

Atlas Forever is being built as the suite's map surface: one window that lists the dungeons and raids the client knows, opens their floors, and keeps the places you name as bookmarks that set the game's own waypoint.

It is not playable yet. This repository currently carries the instance index, the saved bookmark state and the API other Forever addons read; the window, the client map reading and the waypoint button are still to come, so there is nothing to open in game.

## What is here

- **The instance index.** Filter and find entries by continent, map type, level range and a name. A level range is shown only when the client reports it, so a missing upper bound reads as `38+` rather than an invented number.
- **Bookmark state.** Bookmarks are saved per account as plain data, with the most recently viewed places remembered separately.
- **An API for other Forever addons.** `AtlasForever.API` (version 1.1) answers a filtered instance list, one instance by map ID, and asks the window to open one. Until the saved state has loaded it answers `nil`, so a caller asks again after login instead of reading silence as "no instances".
- **Error capture.** Every callback runs through `Core/SafeCall.lua`, so one bad entry cannot take the addon down.

## Install

Copy the `AtlasForever` folder into `_classic_beta_/Interface/AddOns/`, so you end up with `AddOns/AtlasForever/AtlasForever.toc`. After an update, `/reload`.

The addon targets the WoW: Forever client, Interface 16001, and needs nothing else installed.

## Usage

| Command | What it does |
|---|---|
| `/atlas`, `/atlasforever` | Print the bookmark state |

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

Specs run on LuaJIT against a mock client (`tests/wow_mock.lua`), so they need no game client:

```sh
for spec in tests/*_spec.lua; do luajit "$spec" || exit 1; done
```

`Core/Model.lua` is pure and its specs carry no client at all. [AGENTS.md](AGENTS.md) has the full gate, the layout and the rules this repository is held to.

## Credits

Made by cjber. Blizzard Entertainment for the game and its map data. The WoW: Forever project for the client it is written for.

World of Warcraft is a trademark of Blizzard Entertainment, Inc. This addon is not affiliated with or endorsed by Blizzard Entertainment.

## Licence

GPL-3.0-or-later. See [LICENSE](LICENSE).

Made by Cillian Berragan · [cillian.dev](https://cillian.dev) · [GitHub](https://github.com/cjber) · [Twitter](https://twitter.com/cjberragan)

Built with AI assistance.
