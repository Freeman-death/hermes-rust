# Black / Gray / White Theme

Customize tokyonight-night for a near-black background with gray/white
foreground:

```lua
require("tokyonight").setup({
  style = "night",
  transparent = false,
  on_colors = function(c)
    c.bg = "#0a0a0a"
    c.bg_dark = "#050505"
    c.bg_float = "#0a0a0a"
    c.bg_sidebar = "#0a0a0a"
  end,
})
vim.cmd.colorscheme("tokyonight-night")
```

**Prerequisite:** install a Nerd Font (e.g. JetBrainsMono Nerd Font) and set it
in your terminal. Without it, nvim-web-devicons render as boxes instead of
glyphs.

Apply in `lua/plugins.lua` inside the tokyonight plugin spec `config` function.
