return {
  "kidclone3/diagram.nvim",
  dir = vim.fn.expand("~/Documents/nvim-ext/diagram.nvim"),
  dependencies = {
    { "3rd/image.nvim", opts = {} },
  },
  config = function()
    require("diagram").setup({
      events = {
        render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
        clear_buffer = { "BufLeave" },
      },
      integrations = {
        require("diagram.integrations.markdown"),
      },
      renderer_options = {
        mermaid = { theme = "forest" },
      },
    })
  end,
}
