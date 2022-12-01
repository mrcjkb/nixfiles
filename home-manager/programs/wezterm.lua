local wezterm = require("wezterm")
local disableDefaultAssignment = wezterm.action.DisableDefaultAssignment

return {
	font_size = 16.0,
	font = wezterm.font("JetBrains Mono Nerd Font Mono"),
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	color_scheme = "mrcjk",
	hide_tab_bar_if_only_one_tab = true,
	force_reverse_video_cursor = true,
	keys = {
		{
			key = "Enter",
			mods = "ALT",
			action = disableDefaultAssignment,
		},
		{
			key = "phys:6",
			mods = "CTRL|SHIFT",
			action = disableDefaultAssignment,
		},
	},
}
