-- Check for VSCode Neovim extension environment
if vim.g.vscode then
  -- Clipboard
  vim.opt.clipboard = "unnamedplus"

  -- Mapleader
  vim.g.mapleader = " "


  -- Search options
  vim.opt.hlsearch = true
  vim.opt.incsearch = true
  vim.opt.smartcase = true

  -- Show relative line numbers
  vim.opt.relativenumber = true

  -- Cursor style
  vim.opt.guicursor = {
    "n-v-c:block-Cursor", -- Normal, visual - block
    "i-ci-ve:ver25",      -- Insert, Command-line, Visual-ex block - vertical bar
    "r-cr:hor20",         -- Replace, Command-line Replace - underline
    "o:hor50",            -- Operator-pending - underline
  }

  local keymap = vim.keymap.set
  local nvim_keymap = vim.api.nvim_set_keymap

  local opts_silent = { silent = true }
  local opts_nonrecursive = { noremap = true, silent = true }

  local vscode = require('vscode')

  local function vscodemap(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, function() vscode.call(rhs) end, { silent = true, noremap = true })
  end


  -- yank to system clipboard
  keymap({"n", "v"}, "<leader>y", '"+y', opts_nonrecursive)

-- paste from system clipboard
  keymap({"n", "v"}, "<leader>p", '"+p', opts_nonrecursive)

  -- Visual mode: stay in visual while indenting
  keymap("v", ">", ">gv", opts_nonrecursive)
  keymap("v", "<", "<gv", opts_nonrecursive)
  -- move text up and down
  keymap("v", "J", ":m .+1<CR>==", opts_nonrecursive)
  keymap("v", "K", ":m .-2<CR>==", opts_nonrecursive)
  keymap("x", "J", ":move '>+1<CR>gv-gv", opts_nonrecursive)
  keymap("x", "K", ":move '<-2<CR>gv-gv", opts_nonrecursive)
  -- insert mode: jk -> <esc>
  keymap("i", "jk", "<esc>", opts_nonrecursive)

  -- Normal mode: leader mappings
  vscodemap("n", "<leader>/", "editor.action.commentLine")
  vscodemap("n", "<leader>h", "workbench.action.focusLeftGroup")
  vscodemap("n", "<leader>j", "workbench.action.focusBelowGroup")
  vscodemap("n", "<leader>k", "workbench.action.focusAboveGroup")
  vscodemap("n", "<leader>l", "workbench.action.focusRightGroup")
  vscodemap("n", "<leader>ne", "workbench.explorer.fileView.focus")
  vscodemap("n", "<leader>w", "workbench.action.file.save")
  vscodemap("n", "gh", "editor.action.showDefinitionPreviewHover")

  vscodemap("n", "<leader>f", "workbench.action.findInFiles")
  vscodemap("n", "<leader>s", "workbench.action.showAllSymbols")
  vscodemap("n", "<leader>r", "editor.action.startFindReplaceAction")
  vscodemap("n", "<leader>e", "workbench.view.explorer")
  vscodemap("n", "<leader>c", "workbench.action.closeActiveEditor")


  -- Tab navigation
  -- keymap("n", "H", ":call VSCodeNotify('workbench.action.previousEditor')<CR>", opts_nonrecursive)
  -- keymap("n", "L", ":call VSCodeNotify('workbench.action.nextEditor')<CR>", opts_nonrecursive)
  vscodemap("n", "H", "workbench.action.previousEditor")
  vscodemap("n", "L", "workbench.action.nextEditor")

  -- Split navigation
  -- keymap("n", "|", ":vsplit<CR>", opts_nonrecursive)
  -- nvim_keymap("n", "|", ":vsplit<CR>", opts_nonrecursive)
  vscodemap("n", "|", "workbench.action.splitEditor")
  -- keymap("n", "_", ":split<CR>", opts_nonrecursive)
  vscodemap("n", "_", "workbench.action.splitEditorOrthogonal")
  keymap("n", "Q", ":call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts_nonrecursive)
  -- keymap("n", "Q", ":q<CR>", opts_nonrecursive)
  keymap("n", "<Esc>", "<Esc>:noh<CR>", opts_nonrecursive) 

  -- Load folding.lua from same directory as init.lua
  dofile(vim.fn.expand('<sfile>:p:h') .. '/folding.lua')

end



