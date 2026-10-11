# Tally Screen Time for Omarchy

![built with Claude Code](https://img.shields.io/badge/built%20with-Claude%20Code-D97757)
![AI-assisted](https://img.shields.io/badge/AI--assisted-yes-e6edf3)
![directed by human](https://img.shields.io/badge/directed%20by-human-3d444d)

> **This repo is only packaging.** The project itself lives at
> **[lunanoir21/tally-screentime](https://github.com/lunanoir21/tally-screentime)** —
> source, [changelog](https://github.com/lunanoir21/tally-screentime/blob/main/CHANGELOG.md),
> [website](https://lunanoir21.github.io/tally-screentime/), screenshots and the issue
> tracker are all there. Please open bugs and feature requests upstream; issues here are
> limited to the Omarchy wrapper itself (manifest, `Service.qml`, vendoring). If Tally is
> useful to you, a ⭐ on [tally-screentime](https://github.com/lunanoir21/tally-screentime)
> is the best way to say so.

[Tally](https://github.com/lunanoir21/tally-screentime) packaged as an Omarchy shell
plugin: screen time for Quickshell on Hyprland — which apps you focus, for how long,
against a daily goal. A pill on the screen edge, a card that hangs under it (Day, Week and
Map pages, app pages with daily limits, focus sessions), sixteen themes, Turkish and
English, and reports as PNG, one-page PDF, interactive HTML and JSON.

This repo is a thin wrapper. All of Tally's behaviour lives in
[`tally-screentime`](https://github.com/lunanoir21/tally-screentime); the `tally/`
directory here is a vendored, pinned copy of its `ui/` and the two helper scripts under
`tools/` that reports call (currently `v0.1.0`, commit
`049433a04f901389a7a2bb3580faab994cd63a49`), and `Service.qml` is what Omarchy's plugin
loader needs to start it. Nothing is developed here.

`manifest.json` declares `kinds: ["service"]` with `keepLoaded: true` — the same shape as
Omarchy's built-in `background`, `lock` and `notifications` plugins. Tally counts in the
background and owns its own layer-shell windows (the pill, the card, the theme picker, the
first-run tour), so like those it doesn't need omarchy-shell to summon or position
anything. Because a service can't place a widget into Omarchy's bar, the pill gets a small
window of its own at the top-right corner, just under the bar; hide it in Settings
(*Always show in the bar*) if you'd rather use a keybind.

> [!IMPORTANT]
> **Built with AI.** This project was largely written with [Claude Code](https://claude.com/claude-code). The ideas, design decisions, testing and final review are mine.

## Install

```bash
omarchy plugin add https://github.com/lunanoir21/tally-omarchy.git --enable
```

There is nothing else to build or install: Tally is plain QML plus two small Python
helpers, no compiled binary, and it downloads nothing. A first-run tour (language, what it
is, a look, a goal) opens once; it can be skipped.

Open the card by clicking the pill, or bind a key:

```
bind = SUPER, P, exec, qs ipc call lunanoir.tally-screentime toggle
```

(`qs ipc call lunanoir.tally-screentime <open|close|toggle|page|settings|themes|focus|…>` —
the full list is in the [upstream README](https://github.com/lunanoir21/tally-screentime#ipc).)

## What it reads and writes

Tally is local only — no network access at all.

- **Reads** which window has focus (through Quickshell's own toplevel and idle protocols)
  and the desktop entries of the apps you use (names and icons).
- **Writes** `~/.local/state/tally-screentime/settings.json` and `history.json`. It never
  touches `~/.config/omarchy/shell.json` or any other configuration.
- **Only when you ask:** reports go to `~/Pictures/tally/`; *Back up* writes
  `~/tally-history.json`.
- On first run, if a `~/.local/state/pulse-screentime/history.json` (Tally's predecessor)
  exists and Tally has no history yet, it is copied over. Nothing else is imported.

## Configure

Everything is in Tally's own settings page (the sliders icon on the card, or right-click the
pill): pill content, goal, notifications, idle time, excluded apps, history retention,
theme and language.

## Uninstall

```bash
omarchy plugin remove io.github.lunanoir21.tally-screentime
```

Your history stays in `~/.local/state/tally-screentime/`; delete it if you want it gone.

## Requirements

- Hyprland (the card uses Hyprland's focus grab) and Quickshell 0.3+ with Qt 6.6+
- Optional helpers: `python3` with Pillow (or ImageMagick) for PDF reports, `wl-copy` for
  *Copy*, `xdg-open` for *Open*, `notify-send` for notifications, `gsettings` for the
  "follow the system" theme. Without them the matching button simply does nothing.

## Updating the vendored copy

`tally/` is a plain copy, not a git submodule — Omarchy's marketplace clones a single ref
of this repo, and a submodule would need an extra `--recurse-submodules` step outside the
plugin loader's control. To pick up a new release, copy its `ui/` and
`tools/{img2pdf,find_icons}.py` over `tally/`, bump `version` in `manifest.json` and the
commit above, and commit. Watch the
[upstream releases](https://github.com/lunanoir21/tally-screentime/releases).

## License

MIT, same as upstream — see [LICENSE](LICENSE). The bundled fonts (JetBrains Mono,
Bricolage Grotesque) keep their own SIL OFL 1.1 licenses, in `tally/ui/fonts`.

---

<sub>Maintainer note — marketplace submission: category `Widgets`, tags `Bar`, `Hyprland`,
`Quickshell`. `preview.png` is the project's cover image (1280×640).</sub>
