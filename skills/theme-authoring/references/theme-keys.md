# Theme key categories

Palette decision table for darkening a theme. Apply classes 1-4 to the style; leave class 5 unchanged.

| class | value | keys |
|---|---|---|
| Background surfaces → near-black | `#080808` | background, elevated_surface.background, surface.background, panel.background, status_bar.background, title_bar.background, toolbar.background, tab_bar.background, editor.background, editor.subheader.background, terminal.background, editor.active_line.background, editor.highlighted_line.background, scrollbar.track.background |
| Borders / chrome → dark gray | `#1f1f1f` | border, border.disabled, border.variant |
| Active / hover / selected → dark gray | `#2a2a2a` | element.background, element.hover, element.active, element.selected, ghost_element.hover, ghost_element.active, ghost_element.selected, scrollbar.thumb.background, scrollbar.thumb.border, search.match_background |
| Text / syntax / semantic status → keep source | — | text, text.muted, text.accent, syntax.*, terminal.*, editor.foreground, editor.line_number, search.active_match_background |
| Status dot backgrounds → near-black | `#080808` | conflict.background, created.background, deleted.background, error.background, warning.background, info.background, success.background, modified.background, hint.background, predictive.background, renamed.background, unreachable.background |

Notes:
- `syntax` is nested (additionalProperties of a sub-object): enumerate leaf keys such as `syntax.comment.color`, `syntax.function.color`, `syntax.string.color`.
- `players` and `accents` are optional arrays — omit them rather than invent values.
- For non-Zed editors, replace the key list with that editor's own schema, keeping the same class boundaries.
