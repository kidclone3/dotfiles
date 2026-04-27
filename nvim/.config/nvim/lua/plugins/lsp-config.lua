return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config('tailwindcss', {
        capabilities = capabilities,
      })
      vim.lsp.config('ruby_lsp', {
        capabilities = capabilities,
        cmd = { "/home/typecraft/.asdf/shims/ruby-lsp" },
      })
      vim.lsp.config('html', {
        capabilities = capabilities,
      })
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
      })

      vim.lsp.enable({ 'tailwindcss', 'ruby_lsp', 'html', 'lua_ls' })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {})
    end,
  },
}
