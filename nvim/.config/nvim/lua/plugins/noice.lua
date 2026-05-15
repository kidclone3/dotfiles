return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
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
