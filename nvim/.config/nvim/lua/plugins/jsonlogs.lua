return {
  {
    "ll931217/jsonlogs.nvim",
    ft = "jsonl",
    opts = {
      prefix = "<leader>jl",
      auto_open = true,
    },
    keys = {
      { "<leader>j", desc = "JSONL" },
      { "<leader>jl", "<cmd>JsonLogs<CR>", desc = "Open JSONL viewer" },
    },
  },
}
