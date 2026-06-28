vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

-- OSC 52 clipboard provider — sends yanks to the local terminal's clipboard
-- over SSH. Required when editing on a remote server with no X/Wayland display.
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- File / buffer shortcuts (W=save, Q=quit, B=delete buffer)
vim.keymap.set('n', 'W', ':w<CR>')
vim.keymap.set('n', 'Q', ':q<CR>')
vim.keymap.set('n', 'B', ':bd<CR>')

-- ca: copy entire buffer to system clipboard (overrides Vim's ca text-object operator)
vim.keymap.set('n', 'ca', ':%y<CR>')

-- N: run :normal across the visual selection (range auto-prepended to '<,'>)
vim.keymap.set('v', 'N', ':normal ')

-- Toggles: <leader>sc=spell, <leader>sw=wrap
vim.keymap.set('n', '<leader>sc', ':set spell!<CR>')
vim.keymap.set('n', '<leader>sw', ':set wrap!<CR>')
vim.wo.number = true
vim.wo.linebreak = true
