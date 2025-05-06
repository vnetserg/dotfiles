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

config.colors = {
  -- The default text color
  foreground = '#dbdbdb',
  -- The default background color
  background = '#15191e',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#fefefe',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = '000000',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#fefefe',

  -- the foreground color of selected text
  selection_fg = '#000000',
  -- the background color of selected text
  selection_bg = '#bad5fb',

  -- The color of the split lines between panes
  split = '#444444',

  ansi = {
    '#14181d',
    '#708cf7',
    '#57bf37',
    '#c6c43f',
    '#2d42c0',
    '#b148b8',
    '#58c2c5',
    '#c7c7c7',
  },
  brights = {
    '#676767',
    '#a2adf8',
    '#81e397',
    '#eae14a',
    '#a7aaec',
    '#d382db',
    '#8ef9fd',
    '#fefefe',
  },
}

config.text_blink_rate = 0

config.background = {
  {
		source = {
			Color = '#15191e',
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

return config
