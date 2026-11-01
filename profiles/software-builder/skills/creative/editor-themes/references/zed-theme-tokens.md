# Zed Theme Tokens (v0.2.0)

Source schema: https://zed.dev/schema/themes/v0.2.0.json

## UI Tokens by Layer

- **Window/app**: `background`, `surface.background`, `elevated_surface.background`
- **Title bar**: `title_bar.background`, `title_bar.inactive_background`
- **Status/toolbar**: `status_bar.background`, `toolbar.background`
- **Tabs**: `tab_bar.background`, `tab.inactive_background`, `tab.active_background`
- **Panels**: `panel.background`
- **Elements**: `element.background`, `element.hover`, `element.active`, `element.selected`, `element.disabled`
- **Ghost elements**: `ghost_element.*` (same set, used for overlay chrome)
- **Borders**: `border`, `border.variant`, `border.focused`, `border.selected`, `border.disabled`, `border.transparent`
- **Text**: `text`, `text.muted`, `text.placeholder`, `text.disabled`, `text.accent`
- **Icons**: `icon`, `icon.muted`, `icon.disabled`, `icon.placeholder`, `icon.accent`
- **Editor**: `editor.background`, `editor.foreground`, `editor.gutter.background`, `editor.subheader.background`, `editor.active_line.background`, `editor.highlighted_line.background`, `editor.line_number`, `editor.active_line_number`, `editor.hover_line_number`, `editor.invisible`, `editor.wrap_guide`, `editor.active_wrap_guide`, `editor.document_highlight.read_background`, `editor.document_highlight.write_background`, `editor.indent_guide`, `editor.indent_guide_active`
- **Scrollbar**: `scrollbar.thumb.background`, `scrollbar.thumb.hover_background`, `scrollbar.thumb.border`, `scrollbar.track.background`, `scrollbar.track.border`
- **Search**: `search.match_background`, `search.active_match_background`
- **VC/status**: `version_control.added`, `version_control.modified`, `version_control.deleted`, `version_control.word_added`, `version_control.word_deleted`, `version_control.conflict_marker.ours`, `version_control.conflict_marker.theirs`, plus `created`, `deleted`, `error`, `hidden`, `hint`, `ignored`, `info`, `modified`, `predictive`, `renamed`, `success`, `unreachable`, `warning` each with `.background` and `.border` variants.
- **Terminal**: `terminal.background`, `terminal.foreground`, `terminal.bright_foreground`, `terminal.dim_foreground`, `terminal.ansi.{black,red,green,yellow,blue,magenta,cyan,white}` and their `.bright_*` / `.dim_*` variants.
- **Other**: `link_text.hover`, `drop_target.background`, `players` array for multi-cursor colors.

## Palette Design Notes

- Base UI should sit on `#050505`–`#111111` for backgrounds, with surfaces stepping up by roughly one hex step per elevation level.
- Muted UI text: `#555555`–`#888888`. Primary UI text: `#cccccc`–`#e0e0e0`.
- Borders should be barely perceptible in resting state (`#1e1e1e`–`#2a2a2a`), focused state should barely lift (`#3a3a3a`–`#4a4a4a`).
- Accent color for UI chrome: one saturated color, used sparingly for text.accent, icon.accent, search highlights, link hover, and player cursors.
- Syntax colors should remain readable against `#080808`–`#282c34` editor backgrounds. Avoid values below `#222222` for syntax foregrounds unless the user explicitly requests low-contrast.
- `null` is a valid value for tokens that should be unset; Zed will fall back to computed styles.
- `font_weight` accepts integers `100..900`; use integer `700` for bold, not the string `"700"`.
