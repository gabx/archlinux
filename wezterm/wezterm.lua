-- https://wezterm.org/index.html
-- to list keyboard key, run: wezterm show-keys --lua
-- nice starter tuto: https://alexplescan.com/posts/2024/08/10/wezterm/#top

-- to test a setting, run : wezterm --config-file /tmp/wezterm.lua start
-- reload after changes: save file, Ctrl + Shift + R

-- afficher la palette, menu général: CTRL + Shift + P --

-- Import the wezterm module
local wezterm = require("wezterm")
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()
-- (This is where our config will go)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 3000 }

-- Automatically Reload Configurations
config.automatically_reload_config = true

-- GPU rendering
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"

------------------------------------
------ SCHEME DECORATION -----------
------------------------------------

-- Test colorthemes: % bash -c "$(wget -qO- https://git.io/vQgMr)"
-- Theme Kanagawa Dragon -------------------------------------------------------
-- config.colors = require("wezterm").color.get_builtin_schemes()["Kanagawa Dragon"]

--config.color_scheme = "hardhacker" -- important
config.color_scheme = "Tokyo Night" -- important
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

---- FONTS -------------
-- Choose your favourite font, make sure it's installed on your machine
config.font = wezterm.font({ family = "JetBrains Mono" })
-- And a font size that won't have you squinting
config.font_size = 10
config.window_frame = {
	font = wezterm.font({ family = "Berkeley Mono", weight = "Bold" }),
	font_size = 10,
}
-- assure que les fonts peuvent s'afficher en gras
config.bold_brightens_ansi_colors = true

---- STYLE -------------
config.tab_bar_at_bottom = true
config.window_decorations = "NONE"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 800

------------------------------------
------ KEYBOARD KEYS ---------------
------------------------------------

config.keys = {
	-- Fermer le pane courant
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- Split horizontal
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal,
	},
	-- Sélecteur de thème
	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				if label then
					window:set_override_config({ color_scheme = label })
				end
			end),
			title = "Choisir un Thème (Echap pour annuler)",
			description = "Naviguez avec les flèches pour prévisualiser",
			choices = (function()
				local choices = {}
				for name, _ in pairs(wezterm.color.get_builtin_schemes()) do
					table.insert(choices, { label = name })
				end
				table.sort(choices, function(a, b)
					return a.label < b.label
				end)
				return choices
			end)(),
			fuzzy = true,
		}),
	},
	-- Podman container picker
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local containers = get_podman_containers()

			if #containers == 0 then
				window:toast_notification("WezTerm", "No Podman containers found.", nil, 3000)
				return
			end

			window:perform_action(
				wezterm.action.InputSelector({
					title = "Select a Podman container",
					choices = (function()
						local items = {}
						for _, c in ipairs(containers) do
							table.insert(items, {
								label = string.format("%s (%s)", c.name, c.status),
								id = c.name,
							})
						end
						return items
					end)(),
					fuzzy = true,
					action = wezterm.action_callback(function(win, _, id)
						if not id then
							return
						end

						local selected
						for _, c in ipairs(containers) do
							if c.name == id then
								selected = c
							end
						end

						if not selected then
							return
						end

						if not ensure_running(selected) then
							win:toast_notification("WezTerm", "Failed to start container.", nil, 3000)
							return
						end

						win:perform_action(
							wezterm.action.SpawnCommandInNewTab({
								args = {
									"podman",
									"exec",
									"-it",
									selected.name,
									detect_shell(selected.name),
								},
							}),
							pane
						)
					end),
				}),
				pane
			)
		end),
	},
	-- Show how-to file in a separate pane
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 35 },
			command = {
				args = { "nvim", "/development/doc/howto.md" },
			},
		}),
	},
	-- Show passwd file
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 35 },
			command = {
				args = { "bat", "/home/gabx/sync/passwords.txt" },
			},
		}),
	},
}

-----------------------------------------------------------------------------------
-- COPIER COLLER
-----------------------------------------------------------------------------------

config.enable_wayland = true
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"

config.mouse_bindings = {
	-- Clic gauche relâché : copie la sélection dans le presse-papier système
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("Clipboard"),
	},
	-- Clic droit : colle depuis le presse-papier système
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

--------------------------------------------------------------------------------
-- PODMAN INTEGRATION
--------------------------------------------------------------------------------

local function detect_shell(container)
	local shells = { "/bin/zsh", "/usr/bin/zsh", "/bin/bash", "/usr/bin/bash", "/bin/sh" }

	for _, s in ipairs(shells) do
		local success = wezterm.run_child_process({
			"podman",
			"exec",
			container,
			"test",
			"-x",
			s,
		})
		if success then
			return s
		end
	end

	return "/bin/sh"
end

local function get_podman_containers()
	local ok, out = wezterm.run_child_process({
		"podman",
		"ps",
		"-a",
		"--format",
		"{{.Names}}|{{.Status}}",
	})

	if not ok then
		return {}
	end

	local containers = {}
	for line in out:gmatch("[^\r\n]+") do
		local name, status = line:match("([^|]+)|(.+)")
		if name and status then
			table.insert(containers, { name = name, status = status })
		end
	end

	return containers
end

local function ensure_running(container)
	if container.status:match("Exited") or container.status:match("Created") then
		wezterm.log_info("Starting container: " .. container.name)
		local ok = wezterm.run_child_process({ "podman", "start", container.name })
		if not ok then
			wezterm.log_error("Failed to start container: " .. container.name)
			return false
		end
	end
	return true
end

local function build_launch_menu()
	local menu = {}
	local containers = get_podman_containers()
	for _, c in ipairs(containers) do
		table.insert(menu, {
			label = string.format("Container: %s (%s)", c.name, c.status),
			args = { "podman", "exec", "-it", c.name, detect_shell(c.name) },
		})
	end
	return menu
end

config.launch_menu = build_launch_menu()

-----------------------------------------------------------------------
-- END PODMAN SECTION
-----------------------------------------------------------------------

config.default_prog = { "/usr/bin/zsh", "-l" }

-- start yazi on the first pane when launching wezterm
wezterm.on("gui-startup", function()
	-- Onglet 1 : yazi
	local tab, pane, window = wezterm.mux.spawn_window({ args = { "zsh", "-l", "-c", "yazi" } })
	tab:set_title("yazi")

	-- Onglet 2 : zsh
	local zsh_tab, _, _ = window:spawn_tab({ args = { "zsh", "-l" } })
	zsh_tab:set_title("zsh")

	-- Onglet 3 : claude
	local claude_tab, claude_pane, _ = window:spawn_tab({
		args = { "zsh", "-l", "-c", "cd /development && exec zsh" },
		cwd = "/development",
	})
	claude_tab:set_title("claude")
	claude_pane:send_text("cd /development && claude\n")

	-- Focus sur l'onglet 1 au démarrage
	tab:activate()
end)

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
