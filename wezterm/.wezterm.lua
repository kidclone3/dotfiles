local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================
-- WSL as the default shell
-- ============================================================
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '~',
  },
}
config.default_domain = 'WSL:Ubuntu'

-- Extra profiles available via the launcher (Ctrl+Shift+L by default)
config.launch_menu = {
  { label = 'Ubuntu (WSL)', args = { 'wsl.exe', '-d', 'Ubuntu', '--cd', '~' } },
  { label = 'PowerShell',   args = { 'pwsh.exe', '-NoLogo' } },
  { label = 'CMD',          args = { 'cmd.exe' } },
}

-- ============================================================
-- Appearance
-- ============================================================
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback {
  'UbuntuSansMono Nerd Font',
  'JetBrains Mono',
  'Symbols Nerd Font Mono',
}
config.font_size = 12.0
config.line_height = 1.1
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }  -- ligatures on

config.window_background_opacity = 0.97
config.window_decorations = 'RESIZE'      -- frameless look; use 'TITLE | RESIZE' for the standard title bar
config.window_padding = { left = 8, right = 8, top = 6, bottom = 6 }

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

-- ============================================================
-- Scrollback & behavior
-- ============================================================
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false

return config
