# Changelog

All notable changes to Atlas Forever are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses semantic versioning.

## [Unreleased]

## [0.1.0] - 2026-10-26

### Added

- **The instance browser window.** `/atlas` (or `/atlasforever`) opens a searchable list of every dungeon and raid the client reports, with a map pane, floor choices when an instance has more than one map, account-wide bookmarks, and a waypoint button when the client data carries an entrance. The map pane shows a plain fallback line instead of map art, because this client build ships no instance map art in its `UiMap` data.
- **`Core/Model.lua`**, the pure bookmark arithmetic the window draws from: coordinate formatting, adding, removing and searching bookmarks, with duplicate places refused.
- **`Core/Core.lua`** owns the saved variables, the ready callbacks and the `/atlas` command. **`Core/API.lua`** (version 1.1) is the versioned contract other Forever addons read: a filtered instance list, one entry by map ID, and a request to open an entry.
- **A README mock of the browser**, rendered from Forever Core's shared offline renderer against pinned client data, with the selection, divider and action bar the window itself draws.
- **A map marker icon** identifies Atlas Forever in the client and its README, with rendered 400 px and 64 px files.

### Changed

- **The settings-page chrome is Forever Core's shared `UI/SettingsPage.lua`**, vendored and listed in the TOC. Atlas registers no settings page yet, so nothing calls it before one is built.
- **The README and `docs/curseforge.md` follow the suite's shape**: the family block, CI and release badges, what the addon never does, and the credits and licence sections every Forever addon carries.

### For addon authors

- `AtlasForever.API` answers `nil` until the saved state has loaded, so a caller asks again after login rather than reading silence as "no instances".

### Tooling

- Repository scaffold at Interface 16001: the TOC, the suite's shared configuration, CI, the release workflow and the spec harness, plus `.editorconfig`.
- Shared quality tooling: a pinned Sift profile, type checking, secret and locale checks, the dead-code gate and shared-core drift CI.
