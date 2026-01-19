require("yatline"):setup({
    -- === SECTION 1 : VOS COULEURS (Styles) ===
    -- C'est ici que vous définissez l'apparence
    section_separator = { open = "", close = "" },
    part_separator = { open = "", close = "" },
    inverse_separator = { open = "", close = "" },

    style_a = {
        fg = "black",
        bg_mode = {
            normal = "white",
            select = "brightyellow",
            un_set = "brightred"
        }
    },
    style_b = { bg = "brightblack", fg = "brightwhite" },
    style_c = { bg = "black", fg = "brightwhite" },

    permissions_t_fg = "green",
    permissions_r_fg = "yellow",
    permissions_w_fg = "red",
    permissions_x_fg = "cyan",
    permissions_s_fg = "white",

    -- === SECTION 2 : VOS ICONES ===
    selected = { icon = "󰻭", fg = "yellow" },
    copied = { icon = "", fg = "green" },
    cut = { icon = "", fg = "red" },

    total = { icon = "󰮍", fg = "yellow" },
    succ = { icon = "", fg = "green" },
    fail = { icon = "", fg = "red" },
    found = { icon = "󰮕", fg = "blue" },
    processed = { icon = "󰐍", fg = "green" },

    -- === SECTION 3 : OPTIONS ===
    tab_width = 20,
    tab_use_inverse = false,
    show_background = true,
    display_header_line = true,
    display_status_line = true,

    -- J'ai commenté les lignes ci-dessous car elles provoquaient le crash.
    -- Le plugin va utiliser ses valeurs par défaut qui fonctionnent très bien.
    
    -- component_positions = { "header", "tab", "status" },
    -- header_line = { ... },
    -- status_line = { ... },
})