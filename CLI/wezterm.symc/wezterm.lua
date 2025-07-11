-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Dracula"
config.font_size = 14
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- and finally, return the configuration to wezterm
return config

