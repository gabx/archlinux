local vars = require("lua.variables")

hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.cosmic_term))
hl.bind(vars.mainMod .. " + W", hl.dsp.exec_cmd("wezterm start --always-new-process"))
hl.bind(vars.mainMod .. " + F", hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.mainMod .. " + C", hl.dsp.window.close())
hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd("uwsm stop"))

-- Aller au premier bureau vide (sur le moniteur courant)
hl.bind(vars.mainMod .. " + E", hl.dsp.focus({ workspace = "empty" }))

-- Cycler les bureaux du moniteur courant
hl.bind(vars.mainMod .. " + right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(vars.mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
-- Envoyer la fenêtre active sur le premier bureau vide
hl.bind(vars.mainMod .. " + SHIFT + E", hl.dsp.window.move({ workspace = "empty" }))
-- Faire flotter / re-tiler la fenêtre active
hl.bind(vars.mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- Déplacer / redimensionner à la souris (Mod + clic gauche / droit maintenu)
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Changer de bureau (Mod+1..5)
for i = 1, 5 do
	local n = tostring(i)
	hl.bind(vars.mainMod .. " + " .. n, hl.dsp.focus({ workspace = n }))
end
-- Déplacer la fenêtre active vers le bureau N
for i = 1, 5 do
	local n = tostring(i)
	hl.bind(vars.mainMod .. " + SHIFT + " .. n, hl.dsp.window.move({ workspace = n }))
end
-- Aller au premier bureau vide (sur le moniteur courant)
hl.bind(vars.mainMod .. " + E", hl.dsp.focus({ workspace = "empty" }))

-- Cycler les bureaux du moniteur courant
hl.bind(vars.mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(vars.mainMod .. " + left", hl.dsp.focus({ workspace = "m-1" }))
-- fuzzel menu
hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd("fuzzel --launch-prefix='uwsm app -- '"))
-- Screenshot Region -> presse-papier
hl.bind(vars.mainMod .. " + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
-- Sreenshot Region -> fichier
hl.bind(
	vars.mainMod .. " + SHIFT + S",
        hl.dsp.exec_cmd([[f=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png; grim -g "$(slurp)" "$f" && wl-copy < "$f" && notify-send -i "$f" "Capture enregistrée" "$f"]])
)
-- Écran entier → fichier
hl.bind("CTRL + Print", hl.dsp.exec_cmd([[grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png]]))
-- Close notification pop up
hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
