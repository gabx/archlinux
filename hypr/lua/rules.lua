-- Bureaux épinglés aux moniteurs (séquence unique, alternée)
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })

-- Apps épinglées aux bureaux
hl.window_rule({ match = { class = "firefox" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "org.wezfurlong.wezterm" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "chromium" }, workspace = "3 silent" })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird" }, workspace = "5 silent" })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, workspace = "4 silent" })
hl.window_rule({ match = { class = "hl-pnl-box" }, float = true, size = {480, 260}, move = {1432, 38} })
