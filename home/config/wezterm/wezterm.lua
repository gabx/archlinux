-- https://wezterm.org/index.html
-- to list keyboard key, run: wezterm show-keys --lua
-- nice starter tuto: https://alexplescan.com/posts/2024/08/10/wezterm/#top

-- to test a setting, run : wezterm --config-file /tmp/wezterm.lua start
-- reload after changes: save file, Ctrl + Shift + R

-- Import the wezterm module
local wezterm = require("wezterm")
-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()
-- (This is where our config will go)

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

config.color_scheme = "hardhacker" -- important
-- config.color_scheme = "Material"  -- important
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

---- scheme -----------
-- config.color_scheme = 'Cobalt2'
-- config.color_scheme = 'DjangoRebornAgain'
config.color_scheme = "DotGov"
-- config.color_scheme = 'Galaxy'
-- config.color_scheme = 'TokyoNight Moon'

---- FONTS -------------
-- Choose your favourite font, make sure it's installed on your machine
config.font = wezterm.font({ family = "JetBrains Mono" })
-- And a font size that won't have you squinting
config.font_size = 10
config.window_frame = {
	font = wezterm.font({ family = "Berkeley Mono", weight = "Bold" }),
	font_size = 10,
}

---- STYLE -------------
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 800

------------------------------------
------ KEYBOARD KEYS ---------------
------------------------------------
-- shortcut configuration
config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}
config.keys = {
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal,
	},
}

-----------------------------------------------------------------------------------
-- COPIER COLLER
-----------------------------------------------------------------------------------

-- Copie automatiquement dans le presse-papier système dès qu'on sélectionne du texte
config.enable_wayland = true -- Important pour Arch moderne
config.selection_word_boundary = " \t\n{}[]()\"'`,;:" -- Rend la sélection double-clic plus intelligente

-- Optionnel : Désactiver le comportement par défaut du clic droit si gênant
-- config.mouse_bindings = { ... }

--------------------------------------------------------------------------------
-- PODMAN INTEGRATION
--------------------------------------------------------------------------------

-- Detect the right shell inside containers
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

-- Parse podman ps output
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
			table.insert(containers, {
				name = name,
				status = status,
			})
		end
	end

	return containers
end

-- Auto-start container if stopped
local function ensure_running(container)
	if container.status:match("Exited") or container.status:match("Created") then
		wezterm.log_info("Starting container: " .. container.name)

		local ok = wezterm.run_child_process({
			"podman",
			"start",
			container.name,
		})

		if not ok then
			wezterm.log_error("Failed to start container: " .. container.name)
			return false
		end
	end

	return true
end

-- Build dynamic launch menu
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

--------------------------------------------------------------------------------
-- KEYBINDING: Ctrl+a then p → Podman container picker
--------------------------------------------------------------------------------
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
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

						-- Find selected container
						local selected
						for _, c in ipairs(containers) do
							if c.name == id then
								selected = c
							end
						end

						if not selected then
							return
						end

						-- Ensure it's running
						if not ensure_running(selected) then
							win:toast_notification("WezTerm", "Failed to start container.", nil, 3000)
							return
						end

						-- Exec into the container
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
}

-----------------------------------------------------------------------
-- END PODMAN SECTION
-----------------------------------------------------------------------

-- Wayland : laisse WezTerm décider, mais force si besoin :
config.enable_wayland = true

-- Shell par défaut
config.default_prog = { "/usr/bin/zsh", "-l" }

-- start yazi on the first pane when launching wezterm
wezterm.on("gui-startup", function()
	-- Lance yazi dans la fenêtre initiale, avec ton env de zsh (login)
	wezterm.mux.spawn_window({ args = { "zsh", "-l", "-c", "yazi" } })
end)

-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config
