# Nvim Config: macos vs ubuntu Branch Comparison

Branches: `origin/macos` vs `delus-ubuntu-home` (as of 2026-04-23)

## Summary

3 files differ between branches. The ubuntu branch has been updated to use
Neovim 0.11+ APIs, while macos still uses deprecated patterns.

## File-by-File Differences

### `lua/plugins/lsp-config.lua`

| Aspect | macos | ubuntu |
|--------|-------|--------|
| LSP setup method | `require("lspconfig").<server>.setup()` | `vim.lsp.config()` + `vim.lsp.enable()` |
| ruby_lsp | Present (points to `/home/typecraft/.asdf/shims/ruby-lsp`) | Removed |
| tailwindcss | Individual setup call | Loop-based config |
| html | Individual setup call | Loop-based config |
| lua_ls | Individual setup call | Loop-based config |
| Keymaps | Identical | Identical |

### `lua/plugins/treesitter.lua`

| Aspect | macos | ubuntu |
|--------|-------|--------|
| Module | `require("nvim-treesitter.configs")` | `require("nvim-treesitter")` |
| auto_install | `auto_install = true` | `auto_install = { enable = true }` |
| highlight | `{ enable = true }` | `{ enable = true }` |
| indent | `{ enable = true }` | `{ enable = true }` |

### `lazy-lock.json`

4 plugins have updated pin commits on ubuntu:

| Plugin | macos commit | ubuntu commit |
|--------|-------------|---------------|
| alpha-nvim | `7563da4a` | `6c6a89d5` |
| gitsigns.nvim | `8d82c240` | `6d808f99` |
| mason.nvim | `b03fb0f2` | `12ddd182` |
| nvim-lspconfig | `4b7fbaa2` | `e146efac` |

## Identical Files

All other plugin configs are the same between branches:

- `init.lua`
- `lua/config/lazy.lua`
- `lua/vim-options.lua`
- `lua/plugins.lua`
- `lua/plugins/alpha.lua`
- `lua/plugins/catppuccin.lua`
- `lua/plugins/completions.lua`
- `lua/plugins/copilot.lua`
- `lua/plugins/git-stuff.lua`
- `lua/plugins/gitsigns.lua`
- `lua/plugins/lazygit.lua`
- `lua/plugins/neo-tree.lua`
- `lua/plugins/none-ls.lua`
- `lua/plugins/nvim-tmux-navigation.lua`
- `lua/plugins/oil.lua`
- `lua/plugins/render-markdown.lua`
- `lua/plugins/swagger-preview.lua`
- `lua/plugins/telescope.lua`
- `lua/plugins/vim-test.lua`

## Action Items

- [ ] Backport lsp-config and treesitter fixes to macos branch
- [ ] Run `:TSUpdate` and `:Lazy sync` on macos to update plugin pins
