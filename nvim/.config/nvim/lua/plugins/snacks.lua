return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
      -- Wezterm has only limited Kitty graphics protocol support:
      -- floating window rendering works, inline rendering does not.
      -- Snacks auto-disables `inline` when unicode placeholders aren't
      -- supported, so this is mostly explicit documentation.
      doc = {
        inline = false,
        float = true,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.api.nvim_create_user_command("Mdterm", function()
      local file = vim.fn.expand("%:p")
      Snacks.terminal.open("mdterm " .. vim.fn.fnameescape(file), {
        win = { style = "float", border = "rounded" },
      })
    end, { desc = "Preview current markdown file in mdterm" })
  end,
  keys = {
    { "<leader>p", "<cmd>Mdterm<cr>", desc = "Preview md in mdterm" },
  },
}
