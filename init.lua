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

  local opts_silent = { silent = true }
  local opts_nonrecursive = { noremap = true, silent = true }


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
  keymap("n", "<leader>/", ":call VSCodeNotify('editor.action.commentLine')<CR>", opts_nonrecursive)
  keymap("n", "<leader>h", ":call VSCodeNotify('workbench.action.focusLeftGroup')<CR>", opts_nonrecursive)
  keymap("n", "<leader>j", ":call VSCodeNotify('workbench.action.focusBelowGroup')<CR>", opts_nonrecursive)
  keymap("n", "<leader>k", ":call VSCodeNotify('workbench.action.focusAboveGroup')<CR>", opts_nonrecursive)
  keymap("n", "<leader>l", ":call VSCodeNotify('workbench.action.focusRightGroup')<CR>", opts_nonrecursive)
  keymap("n", "<leader>ne", ":call VSCodeNotify('workbench.explorer.fileView.focus')<CR>", opts_nonrecursive)
  keymap("n", "<leader>w", ":call VSCodeNotify('workbench.action.file.save')<CR>", opts_nonrecursive)
  keymap("n", "gh", ":call VSCodeNotify('editor.action.showDefinitionPreviewHover')<CR>", opts_nonrecursive)
  keymap("n", "<leader>1", ":call VSCodeNotify('workbench.action.openEditorAtIndex1')<CR>", opts_nonrecursive)
  keymap("n", "<leader>2", ":call VSCodeNotify('workbench.action.openEditorAtIndex2')<CR>", opts_nonrecursive)
  keymap("n", "<leader>3", ":call VSCodeNotify('workbench.action.openEditorAtIndex3')<CR>", opts_nonrecursive)
  keymap("n", "<leader>f", ":call VSCodeNotify('workbench.action.findInFiles')<CR>", opts_nonrecursive)
  keymap("n", "<leader>s", ":call VSCodeNotify('workbench.action.showAllSymbols')<CR>", opts_nonrecursive)
  keymap("n", "<leader>r", ":call VSCodeNotify('editor.action.startFindReplaceAction')<CR>", opts_nonrecursive)
  keymap("n", "<leader>e", ":call VSCodeNotify('workbench.view.explorer')<CR>", opts_nonrecursive)
  keymap("n", "<leader>c", ":call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts_nonrecursive)
  -- Tab navigation
  keymap("n", "H", ":call VSCodeNotify('workbench.action.previousEditor')<CR>", opts_nonrecursive)
  keymap("n", "L", ":call VSCodeNotify('workbench.action.nextEditor')<CR>", opts_nonrecursive)

  -- Split navigation
  keymap("n", "|", ":vsplit<CR>", opts_nonrecursive)
  keymap("n", "_", ":split<CR>", opts_nonrecursive)
  -- keymap("n", "Q", ":call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", opts_nonrecursive)
  keymap("n", "Q", ":q<CR>", opts_nonrecursive)
  keymap("n", "<Esc>", "<Esc>:noh<CR>", opts_nonrecursive) 

  -- Load folding.lua from same directory as init.lua
  dofile(vim.fn.expand('<sfile>:p:h') .. '/folding.lua')

end
