#!/usr/bin/env python3
"""Render the Atlas Forever instance browser with the pinned Forever client UI art."""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE = Path(os.environ.get("FOREVER_CORE", ROOT.parent / "forever-core"))
sys.path.insert(0, str(CORE / "tools" / "wowmock"))
import wowmock  # noqa: E402


def browser(ui):
    panel, x, y = wowmock.basic_panel(ui, "Atlas Forever", 860, 540)
    canvas = ui.canvas(872, 548)
    canvas.paste(panel, 0, 0)
    # Left column: Blizzard's search box and a compact instance list.
    wowmock.search_box(canvas, x + 20, y + 48, 228, 22, "Search instances")
    canvas.text(x + 20, y + 82, "Dungeons and raids", wowmock.FONTS["GameFontNormal"])
    # A restrained selected state sits behind the first row, as in the actual scroll list.
    canvas.fill(x + 14, y + 101, 258, 29, (0.12, 0.38, 0.62, 0.48))
    instance_rows = [
        row
        for row in ui.table("Map").values()
        if row["MapType"] == "2"
        and row["InstanceType"] in {"1", "2"}
        and not row["MapName_lang"].startswith("<")
        and not row["Directory"].lower().startswith(("test", "cash"))
    ]
    instance_rows.sort(key=lambda row: row["MapName_lang"].casefold())
    rows = instance_rows[:8]
    for index, row in enumerate(rows):
        top = y + 108 + index * 34
        canvas.text(x + 24, top, row["MapName_lang"], wowmock.FONTS["GameFontHighlight"])
    canvas.fill(x + 273, y + 96, 1, 356, (0.02, 0.02, 0.025, 0.82))
    selected = rows[0] if rows else None
    if selected:
        canvas.text(x + 284, y + 48, selected["MapName_lang"], wowmock.FONTS["GameFontNormalLarge"])
        kind = "Dungeon" if selected["InstanceType"] == "1" else "Raid"
        canvas.text(x + 284, y + 72, kind, wowmock.FONTS["GameFontHighlightSmall"])
        canvas.fill(x + 280, y + 100, 570, 350, (0.025, 0.035, 0.05, 0.82))
        canvas.nine_slice(wowmock.INSET_FRAME_LAYOUT, x + 280, y + 100, 570, 350)
        canvas.text(
            x + 300,
            y + 260,
            "The client does not provide map art for this instance.",
            wowmock.FONTS["GameFontHighlightSmall"],
        )
    else:
        canvas.fill(x + 280, y + 100, 570, 350, (0.025, 0.035, 0.05, 0.82))
        canvas.nine_slice(wowmock.INSET_FRAME_LAYOUT, x + 280, y + 100, 570, 350)
        canvas.text(x + 300, y + 260, "No instances are in this client build.", wowmock.FONTS["GameFontHighlightSmall"])
    canvas.fill(x + 280, y + 464, 570, 44, (0.02, 0.025, 0.035, 0.9))
    canvas.nine_slice(wowmock.INSET_FRAME_LAYOUT, x + 280, y + 464, 570, 44)
    wowmock.ui_panel_button(canvas, x + 547, y + 474, 146, 24, "Set waypoint")
    wowmock.ui_panel_button(canvas, x + 701, y + 474, 138, 24, "Bookmark")
    return canvas


def main():
    ui = wowmock.Ui(scale=2)
    canvas = browser(ui)
    output = ROOT / "docs" / "screenshots" / "window.png"
    output.parent.mkdir(parents=True, exist_ok=True)
    canvas.image.save(output, optimize=False)
    print(output)


if __name__ == "__main__":
    main()
