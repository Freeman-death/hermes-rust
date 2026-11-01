---
name: theme-authoring
description: "Customize code-editor themes: darken backgrounds."
version: 1.0.0
author: Hermes Agent + Solar
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [themes, editor, ui, theming]
    related_skills: [hermes-agent]
---

## When to Use

Load this skill when the user asks to:
- darken or recolor an existing code-editor / UI theme;
- create a new variant of an existing theme (e.g., a blacker or monochrome version);
- generate a theme file from a schema rather than hand-writing it.

# Theme Authoring

Author and customize code-editor / UI color themes: darken backgrounds, keep syntax highlighting, produce valid theme files, and preview the result for the user.

## Always-on rules

- Answer short and direct: no filler, no "Great question", no restating the request, no narrating tool calls. A finished deliverable is a short report of what changed and what was verified.
- Correct false premises plainly: do not agree with a false assertion (e.g., letter counts) to be agreeable.
- On personal topics, ask deep questions and help them see why they think/feel that way before answering.
- Plan before writing any code.
- Prefer lightweight, low-failure-rate solutions (local-first, minimal compute — especially on low-power hardware).
- When building something, prefer Rust.

## Procedure — darken an existing theme to black

1. **Locate the theme directory.** For Zed: `~/.config/zed/themes/*.json`. For other editors, find the editor's theme directory (VS Code: `~/.config/Code/User/` or `UserData/Themes`; etc.).
2. **Read the schema.** Fetch the editor's theme schema and enumerate the valid top-level style keys. Do not hand-guess keys: an unknown key is ignored and a typo becomes a silent miss.
3. **Enumerate the source's keys.** Read the source and de-duplicate+sort its style keys. This is your pristine list of "untouched" keys the generator must preserve exactly.
4. **Map the palette.** Decide what changes and what stays:
   - Borders / chrome → dark gray.
   - Sub-surfaces (toolbars, panels, tabs, title bar, status bar) → near-black.
   - Active / hover / selected states → dark gray, so selection still reads.
   - Syntax, terminal, text, semantic status colors → keep source values unchanged.
5. **Generate, don't hand-edit.** Write a script that deep-copies the source style and overwrites only the mapped keys. This preserves untouched keys exactly and prevents typos.
6. **Write a new theme file** in the themes folder. Never overwrite the source theme.
7. **Validate** with `python3 -m json.tool <file>`; confirm the darkened values are present.
8. **Preview** by rendering a palette HTML with the editor's theme variables and the inline `::preview{file=...}` directive.

## Pitfalls

- **Pick the theme by name+appearance, not by array index.** Theme files commonly hold several entries in one array (light + dark). Using `[1]` when `[0]` is the dark theme silently produces a light theme — verify by name first.
- **The `syntax` object is nested** (additionalProperties of a sub-object). Enumerate its leaf keys separately; setting `syntax.comment.color` as a flat key will not work.
- **Never overwrite the source.** Emit a new file so a correction loop can back out.
- **Don't invent optional array fields** (e.g., `accents`, `players`). Omit them; they are optional.
- **Keep syntax/terminal/text colors stable.** Darkening them turns code unreadable or breaks the terminal palette — the user asked for dark backgrounds and borders, not colorless code.
- **Check for name collisions** before writing; the folder should not duplicate a theme name.
- **Border darkening is optional.** If you leave borders at source values, they read as bright lines on a black background. Darken chrome borders to dark gray.

## References

- `references/theme-keys.md` — palette decision table and key categories.
- `templates/theme.json` — starter theme skeleton to copy and pass through the generator.
