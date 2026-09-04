local function image_backend()
  -- WezTerm's Kitty graphics implementation is incomplete, but its Sixel
  -- implementation works with image.nvim. Query tmux's attached client so
  -- this also works when reattaching a long-lived session from another
  -- terminal.
  if vim.env.TMUX then
    local client = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "#{client_termname}" }))
    local outer_program = vim.trim(vim.fn.system({ "tmux", "show-environment", "-g", "TERM_PROGRAM" }))
    if
      (vim.v.shell_error == 0 and client == "wezterm")
      or outer_program == "TERM_PROGRAM=WezTerm"
    then
      return "sixel"
    end
  elseif vim.env.TERM == "wezterm" or vim.env.TERM_PROGRAM == "WezTerm" then
    return "sixel"
  end

  return "kitty"
end

return {
  "kidclone3/diagram.nvim",
  dir = vim.fn.expand("~/Documents/nvim-ext/diagram.nvim"),
  dependencies = {
    {
      "3rd/image.nvim",
      opts = {
        backend = image_backend(),
        processor = "magick_cli",
        window_overlap_clear_enabled = true,
      },
    },
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
