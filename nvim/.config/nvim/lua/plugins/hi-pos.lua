return {
  "maxonvim/hi-pos.nvim",
  config = function()
    local pos = require("hi_pos").setup()

    -- Uses <leader>P (capital) prefix: <leader>p is already mapped to Mdterm.
    vim.keymap.set("n", "<leader>Ps", pos.start, { desc = "Start POS highlighting" })
    vim.keymap.set("n", "<leader>PS", pos.stop, { desc = "Stop POS highlighting" })
    vim.keymap.set("n", "<leader>Pt", pos.toggle, { desc = "Toggle POS highlighting" })
  end,
}
