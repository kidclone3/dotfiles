return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    { "<Esc>", "<cmd>nohlsearch<bar>Noice dismiss<CR>", desc = "Clear search highlight & dismiss notifications" },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
      },
    },
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    presets = {
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
