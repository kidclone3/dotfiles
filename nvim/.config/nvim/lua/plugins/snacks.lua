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
}
