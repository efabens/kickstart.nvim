# AGENTS.md - Neovim Kickstart Configuration

## Commands
- **Format Lua**: `stylua .` (uses .stylua.toml config)
- **Check health**: Run `:checkhealth` inside Neovim
- **Plugin management**: `:Lazy` to view/update plugins, `:Mason` for LSP tools

## Architecture
- `init.lua` - Main config file (single-file approach), handles options, keymaps, and plugin setup via lazy.nvim
- `lua/kickstart/plugins/` - Optional bundled plugins (neo-tree, gitsigns, debug, lint, autopairs, indent_line)
- `lua/custom/plugins/` - User's custom plugin configurations (import via `{ import = 'custom.plugins' }`)

## Code Style (Lua)
- **Formatter**: stylua (column_width=160, indent=2 spaces, single quotes preferred)
- **Conventions**: Use `vim.o` for options, `vim.keymap.set()` for keymaps, `vim.api` for autocmds
- **Leader key**: Space (`<leader>`)
- **Plugin format**: Use lazy.nvim spec with `opts = {}` for simple setup, `config = function()` for complex

## Key Bindings
- `<leader>s*` for Search commands, `<leader>t*` for Toggle commands, `<leader>h*` for Git Hunk
- `gr*` for LSP goto commands (grn=rename, gra=code action, grr=references, grd=definition)
