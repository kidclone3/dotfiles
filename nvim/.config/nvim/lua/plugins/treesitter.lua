return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      local parsers = {
        "bash", "c", "css", "diff", "dockerfile", "gitcommit", "go",
        "html", "javascript", "json", "jsonc", "lua", "luadoc",
        "markdown", "markdown_inline", "python", "query", "regex",
        "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf = args.buf
          if pcall(vim.treesitter.start, buf) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
