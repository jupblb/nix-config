local wezterm = require('wezterm')

return {
	allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace',
	automatically_reload_config = false,
	color_scheme = "Gruvbox light, hard (base16)",
	check_for_updates = false,
	default_prog = fish,
	enable_csi_u_key_encoding = true,
	enable_tab_bar = false,
	font = wezterm.font_with_fallback {
		'Iosevka Term Custom',
		'JetBrains Mono',
	},
	font_size = font_size,
	keys = {
		{
			key = 'f',
			mods = 'SUPER|CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = 'Enter',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
		},
		{
			key = '"',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
		},
		{ key = '~', mods = 'CTRL|SHIFT', action = wezterm.action.ShowTabNavigator },
	},
	native_macos_fullscreen_mode = true,
	scrollback_lines = 10000,
	window_close_confirmation = 'NeverPrompt',
	window_frame = {
		border_left_width = 0,
		border_right_width = 0,
		border_bottom_height = 0,
		border_top_height = 0,
	},
	window_padding = { top = 0, bottom = 0 },
}
