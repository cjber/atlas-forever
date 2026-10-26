---
name: sift-project
description: Project profile for Sift quality gates in Atlas Forever.
---

# Sift project profile: Atlas Forever

Atlas Forever targets WoW: Forever (Interface 16001). It reads map and instance metadata from the live client APIs and stores player bookmarks in `AtlasForeverDB`. The saved data is player-owned state, not a cache of client map tables.

## Gate

Run from the repository root: `stylua --check .`, `luacheck .`, every `tests/*_spec.lua` with LuaJIT, Ruff 0.16.8 on `tools`, `python3 tools/changelog.py --check`, `tools/typecheck.sh`, then `.sift/gate.py --base origin/main` and `.sift/agents.py check`.

## Live roots

- `AtlasForever.toc` is the client's file list and load order.
- `Core/Model.lua` owns pure search, filtering and bookmark ordering; it must stay free of WoW APIs and frames.
- `Core/Core.lua` owns SavedVariables, readiness and slash commands.
- `Core/API.lua` is the versioned addon-to-addon contract.
- Client map APIs are the only source for maps, instances and coordinates; never hand-write their data.
