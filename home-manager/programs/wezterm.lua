local wezterm = require("wezterm")

local function disableDefaultAssignment(keymap)
	return {
		key = keymap.key,
		mods = keymap.mods,
		action = wezterm.action.DisableDefaultAssignment,
	}
end

return {
	font_size = 16.0,
	font = wezterm.font("JetBrains Mono Nerd Font Mono"),
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	color_scheme = "mrcjk",
	hide_tab_bar_if_only_one_tab = true,
	force_reverse_video_cursor = true,
	keys = {
		disableDefaultAssignment({
			key = "Enter",
			mods = "ALT",
		}),
		disableDefaultAssignment({
			key = "n",
			mods = "CTRL",
		}),
		disableDefaultAssignment({
			key = "6",
			mods = "SHIFT|CTRL",
		}),
	},
}
