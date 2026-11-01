---
name: editor-themes
description: Create and deliver valid code editor and terminal themes.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [zed, vscode, helix, kitty, ghostty, themes]
    related_skills: []
---

# Editor Themes

## Trigger

Use when the user asks to create, modify, author, review, or install a theme for a code editor, IDE, or terminal.

## Standing Rules

1. Before writing any theme file, fetch the editor's official schema and a known-good reference theme. Treat the reference as the scaffold; modify it rather than drafting from memory.
2. Ask for one concrete aesthetic target before generating: base palette philosophy (e.g. near-black + dark-gray elevation vs. true black + minimal accents), whether syntax should be colorful or restrained, and any colors to avoid.
3. Keep UI chrome on the dark-neutral axis: near-black background, dark-gray surfaces, mid-gray hover/active, light-gray text. Reserve saturated color for syntax, errors, warnings, and focused-state accents only.
4. Borders should be subtle in resting state (`#1e1e1e`–`#2a2a2a`) and lift only slightly in focused state (`#3a3a3a`–`#4a4a4a`). Never use bright UI accent colors for borders unless the user explicitly requests it.
5. Muted UI text, placeholders, and inactive tabs should be mid-gray (`#555555`–`#888888`), never pure white.
6. Terminal ANSI colors should map to the same palette family as syntax: red for errors/deletions, green for additions/success, yellow for warnings, blue for info/accent, magenta for specials, cyan for operators, white for primary text.
7. Always write the complete valid theme file and provide a concrete file path. Do not narrate the generation process.
8. Never edit files inside the editor's bundled install directory. Target the user-level themes directory and tell the user to restart the editor after copying.

## Procedure

1. Identify the editor. If unknown, ask the user.
2. Fetch the editor's theme schema URL and one reference theme. For Zed, use `https://zed.dev/schema/themes/v0.2.0.json` and https://github.com/zed-industries/zed/tree/main/assets/themes.
3. Determine theme folder location. Standard locations are in `references/theme-sources.md`. Verify with a search if uncertain.
4. Read the schema to identify required fields, appearance modes, and available UI tokens.
5. Build the complete theme object: family metadata, theme entry with `appearance`, `style` with all UI tokens, `syntax` map, `terminal` ANSI colors, `players` for cursors. Use `references/zed-theme-tokens.md` for Zed token guidance.
6. Save the theme to a writable location. If the user-level themes dir is reachable, drop it there directly; otherwise save to `~/.hermes/cache/themes/<editor>/<theme-name>.json`.
7. Report the file path, theme name, and the exact menu action to select it. If the editor was running, remind the user to restart.

## Pitfalls

- Generating a partial theme without all required schema fields causes the editor to reject or ignore the file silently. Always include the full `style` object from a known-good reference, even for tokens you leave as `null`.
- Omitting a required key is not the same as setting it to `null`. Zed distinguishes missing keys from explicit `null` overrides. Required keys must be present.
- Theme folder location varies by OS and packaging method. On macOS/Linux it is usually `~/.config/<editor>/themes/`, on Windows `%APPDATA%\<editor>\themes\`. Flatpak/snap installs may use `$XDG_DATA_HOME`. Verify before writing.
- `font_weight` accepts integers `100..900`; use integer `700` for bold, not the string `"700"`, or the parser may reject the token.
- GitHub raw theme URLs often 404 due to URL encoding; use `?plain=1` on blob URLs or clone the repo locally to inspect themes.
- A theme that is only saved in the chat cache is not installed. If you cannot write to the editor's themes dir, save locally and give the user a copy command or clear download instructions.

## references/

- `references/zed-theme-tokens.md` — Zed v0.2.0 style token reference and palette design notes.
- `references/theme-sources.md` — Canonical URLs for official theme files and schemas by editor, plus user themes directory locations.
