local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local action = wezterm.action
 
config.font = wezterm.font {
  family = 'Hack Nerd Font Mono',
  weight = 'Medium',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- disable ligatures
}
config.font_size = 14.0
config.line_height = 1.0

config.hide_tab_bar_if_only_one_tab = true

config.color_scheme = "Catppuccin Mocha"

config.text_blink_rate = 0

config.background = {
  {
		source = {
			Color = '#1e1e2e',
		},
		height = '100%',
		width = '100%',
	},
  {
    source = {
      File = wezterm.home_dir .. '/.config/wezterm/background.jpg',
    },
    opacity = 0.1,
    vertical_align = 'Middle',
    horizontal_align = 'Center',
  },
}

config.keys = {
 {
   key = 'c',
   mods = 'OPT',
   action = wezterm.action.CopyTo 'Clipboard',
 },
 {
   key = 'v',
   mods = 'OPT',
   action = wezterm.action.PasteFrom 'Clipboard',
 },
}

config.native_macos_fullscreen_mode = true

return config
