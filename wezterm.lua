local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.unicode_version = 15

-- General
config.font_size = 18
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Symbols Nerd Font Mono",
})

-- Window title font
config.window_frame = {
	font = wezterm.font_with_fallback({
		{ family = "JetBrainsMono Nerd Font", weight = "Bold" },
		"Symbols Nerd Font Mono",
	}),
	font_size = 18.0,
}

config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.initial_cols = 132
config.initial_rows = 38
config.enable_kitty_graphics = true

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- Performance
config.front_end = "WebGpu"

-- Usability
config.warn_about_missing_glyphs = false
config.audible_bell = "Disabled"

-- Allow Option key to be used for dead keys on macOS (for ç, accents, etc)
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

return config
