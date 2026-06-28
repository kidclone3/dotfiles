vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = false, silent = true })

local vscode = require('vscode')

local function vscodemap(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, function() vscode.call(rhs) end, { silent = true, noremap = true })
end

-- Remap folding keys
vscodemap('n', 'zM', 'editor.foldAll')
vscodemap('n', 'zR', 'editor.unfoldAll')
vscodemap('n', 'zc', 'editor.fold')
vscodemap('n', 'zC', 'editor.foldRecursively')
vscodemap('n', 'zo', 'editor.unfold')
vscodemap('n', 'zO', 'editor.unfoldRecursively')
vscodemap('n', 'za', 'editor.toggleFold')
