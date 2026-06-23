-- Configuration des Options (API native Hyprland Lua 0.55+)

-- Écran principal
-- hl.monitor() prend une table : output / mode / position / scale
hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- Configuration Clavier (AZERTY) + comportement souris
-- hl.config() est une FONCTION qui prend une table, pas une table indexable
hl.config({
	input = {
		kb_layout = "ch",
		kb_variant = "fr",
		follow_mouse = 1,
	},
})

-- Espacement et Bordures
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = "0xff7aa2f7",
			inactive_border = "0xff414868",
		},
	},
})
hl.config({
	misc = {
		background_color = "rgb(004687)",
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})
