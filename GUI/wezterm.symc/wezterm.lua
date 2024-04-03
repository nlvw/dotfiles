local wezterm = require 'wezterm'
local config = {}

-- Colors
config.color_scheme = 'Dracula'

-- Fonts
config.font = wezterm.font 'SourceCode Pro'
config.font_size = 16.0

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Appearance
config.window_background_opacity = 0.9
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Behaviour
config.window_close_confirmation = 'NeverPrompt'

return config
