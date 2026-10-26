# Changelog

All notable changes to Atlas Forever are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses semantic versioning.

## [Unreleased]

### Added

- **An instance browser window with search, bookmarks, floor selection and map coordinates where available**, so players can browse the client’s instance list in one place.
- **A native-style README mock screenshot**, rendered from the shared Forever Core UI renderer and pinned client data.

### Changed

- **The settings-page chrome is now Forever Core's shared `UI/SettingsPage.lua`**, vendored byte for byte and listed in the TOC. Atlas registers no settings page yet, so nothing calls it before one is built.

- The README and the new `docs/curseforge.md` follow the suite's shape: the family block, CI and release badges, what the addon never does, and the credits and licence sections every Forever addon carries. They also say plainly that the window, the client map reading and the waypoint button are not built yet.

### Added

- **A map marker icon now identifies Atlas Forever in the client and its README.** The icon follows the family template and has rendered 400 px and 64 px files.
- Shared quality tooling, a pinned Sift profile, type checking, secret and locale checks, plus shared-core drift CI.
- `.editorconfig`, the family template every other Forever addon already carried.

### Added

- Repository scaffold: the TOC at Interface 16001, the Forever suite's shared configuration, CI, the release workflow and the spec harness.
- `Core/Model.lua`, the pure bookmark arithmetic the window draws from: coordinate formatting, adding, removing and searching bookmarks, with duplicate places refused.
- `Core/Core.lua`, which owns the saved variables, the ready callbacks and the `/atlas` slash command, and `Core/API.lua`, the versioned contract other Forever addons read.
