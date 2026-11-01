---
name: neovim-setup
description: "Set up Neovim for C/C++ and Rust development from scratch."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [neovim, nvim, vim, editor, cpp, rust, lsp, setup, github]
    category: software-development
    related_skills: [github, repo-push-verification]
---

# Neovim Setup from Scratch

Build a Neovim development environment from scratch for C/C++ and Rust projects,
committed to a git repo and pushed to GitHub.

## When to Use

Use when starting a new terminal-editor dev environment for C/C++ and Rust
projects: initializing git, creating the GitHub repo, bootstrapping lazy.nvim,
writing Lua config modules, installing plugins and LSP servers, then committing
and pushing.

## Procedure

### 1. Initialize the local git repo
```
git init
git checkout -b main
```
Create `.gitignore` covering `lazy/`, `mason/`, `undo/`, `backup/`, `swap/`, `*.log`,
and `plugged/` (if using vim-plug).

**Pitfall:** `git init <branch-name>` creates a directory named after the branch,
not a branch. Always run `git init` first, then `git checkout -b main`.

### 2. Create the GitHub repo
```
gh repo create <owner>/<name> --description "<one-line>" --private -y
git remote add origin https://github.com/<owner>/<name>.git
```

### 3. Bootstrap lazy.nvim
Clone to `~/.local/share/nvim/lazy/lazy.nvim`, then prepend its path to
`vim.opt.rtp` in `init.lua` before requiring plugins.

### 4. Write config modules
- `init.lua` — entry point: leader key, disable netrw, require modules,
  call `require("lazy").setup()`
- `lua/config/options.lua` — editor settings (termguicolors, numbers, tabs,
  search, persistence, fold)
- `lua/config/keymaps.lua` — leader mappings, LSP, telescope, file explorer,
  terminal, quickfix
- `lua/config/autocmds.lua` — filetype-specific `makeprg`/`errorformat` for
  gcc/g++/cargo, build/test/fmt maps
- `lua/plugins.lua` — lazy.nvim plugin spec

### 5. Install plugins
```
nvim --headless "+Lazy sync" "+qa"
```
Verify plugins landed in `~/.local/share/nvim/lazy/`.

**Pitfall:** `:Lazy sync` can hang on Mason build tasks. If running headless,
add `vim.defer_fn(function() vim.cmd('qa') end, <ms>)` or allow a longer
timeout.

### 6. Install LSP servers
Use `mason-lspconfig.setup({ensure_installed = {"clangd", "rust_analyzer"}})`
for auto-install on first use.

**Pitfall:** `mason-registry:get_package()` API is unstable across versions.
Prefer `ensure_installed` in `mason-lspconfig.setup()` over imperative
`get_package(...):install()`.

### 7. Commit and push
```
git add -A
git commit -m "<descriptive message>"
git push -u origin main
```

## User preferences (always on)
- Spartan responses: short, direct, no filler, no restating the request
- Address as mr. freeman
- Always commit at each meaningful stage; build from scratch
- C/C++ and Rust focused
- When converting a Vim config/prompt to Neovim: change only Neovim files;
  never read or modify ~/.vimrc or any Vim tree. Stash existing nvim config
  before replacing it so prior work is recoverable.
- Icons require a Nerd Font (e.g. JetBrainsMono Nerd Font); without it,
  devicons render as boxes

## Theme customization (black/gray/white)
See `references/black-gray-white-theme.md`.

## Plugins
Core set: lazy.nvim, tokyonight, nvim-web-devicons, nvim-tree, lualine,
bufferline, nvim-cmp, luasnip, mason, mason-lspconfig, nvim-lspconfig,
telescope, fzf-native, nvim-treesitter, gitsigns, nvim-autopairs,
Comment.nvim, which-key, toggleterm, todo-comments, crates.nvim, lspkind.