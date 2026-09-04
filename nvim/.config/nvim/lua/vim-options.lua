vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false

local is_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
vim.opt.clipboard = "unnamedplus"

if is_ssh and vim.env.TMUX == nil then
  -- OSC 52 clipboard reads are often blocked by terminals. Send copies to the
  -- terminal, but serve paste from a local cache so reads never block.
  local osc52 = require("vim.ui.clipboard.osc52")
  local cache = {
    ["+"] = { {}, "v" },
    ["*"] = { {}, "v" },
  }

  local function copy(reg)
    local send = osc52.copy(reg)

    return function(lines, regtype)
      cache[reg] = { vim.deepcopy(lines), regtype }
      send(lines)
    end
  end

  local function paste(reg)
    return function()
      return vim.deepcopy(cache[reg])
    end
  end

  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = {
      ["+"] = copy("+"),
      ["*"] = copy("*"),
    },
    paste = {
      ["+"] = paste("+"),
      ["*"] = paste("*"),
    },
  }
end


vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- File / buffer shortcuts (W=save, Q=quit, B=delete buffer)
vim.keymap.set('n', 'W', ':w<CR>')
vim.keymap.set('n', 'Q', ':q<CR>')
vim.keymap.set('n', 'B', ':bd<CR>')

-- ca: copy entire buffer to system clipboard (overrides Vim's ca text-object operator)
vim.keymap.set('n', 'ca', ':%y+<CR>')

-- N: run :normal across the visual selection (range auto-prepended to '<,'>)
vim.keymap.set('v', 'N', ':normal ')

-- Toggles: <leader>sc=spell, <leader>sw=wrap
vim.keymap.set('n', '<leader>sc', ':set spell!<CR>')
vim.keymap.set('n', '<leader>sw', ':set wrap!<CR>')

-- Ctrl+/ to toggle comments (matches VS Code / JetBrains muscle memory)
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, desc = 'Toggle comment line' })
vim.keymap.set('v', '<C-_>', 'gcgv', { remap = true, desc = 'Toggle comment, keep selection' })

-- Keep selection after indent/outdent
vim.keymap.set('v', '<', '<gv', { desc = 'Outdent, keep selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent, keep selection' })
vim.wo.number = true
vim.wo.linebreak = true

-- Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
