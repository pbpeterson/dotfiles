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

-- Theme: Kanagawa Wave (canonical palette, defined inline so colors are exact/stable).
-- WezTerm ships a built-in "Kanagawa (Gogh)" scheme with this same wave palette,
-- but a custom color_schemes entry guarantees the exact hex values regardless of build.
config.color_schemes = {
	["Kanagawa Wave"] = {
		background = "#1F1F28",
		foreground = "#DCD7BA",

		cursor_bg = "#C8C093",
		cursor_fg = "#1F1F28",
		cursor_border = "#C8C093",

		selection_bg = "#2D4F67",
		selection_fg = "#C8C093",

		ansi = {
			"#090618", -- black
			"#C34043", -- red
			"#76946A", -- green
			"#C0A36E", -- yellow
			"#7E9CD8", -- blue
			"#957FB8", -- magenta
			"#6A9589", -- cyan
			"#C8C093", -- white
		},
		brights = {
			"#727169", -- bright black
			"#E82424", -- bright red
			"#98BB6C", -- bright green
			"#E6C384", -- bright yellow
			"#7FB4CA", -- bright blue
			"#938AA9", -- bright magenta
			"#7AA89F", -- bright cyan
			"#DCD7BA", -- bright white
		},
	},
}
config.color_scheme = "Kanagawa Wave"

config.window_decorations = "NONE"
config.enable_tab_bar = false
config.initial_cols = 132
config.initial_rows = 38
config.enable_kitty_graphics = true

-- Optional subtle polish (uncomment to enable):
-- config.window_background_opacity = 0.96
-- config.macos_window_background_blur = 20

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- Performance
config.front_end = "WebGpu"

-- Usability
config.warn_about_missing_glyphs = false
config.audible_bell = "Disabled"

-- Left Option = Meta (for tmux M- bindings); Right Option = dead keys (ç, accents)
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

return config
