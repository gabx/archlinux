-- window frame, tab style etc --

local M = {}

function M.setup(config)
      config.use_fancy_tab_bar = true
      config.tab_bar_at_bottom = false
      config.window_decorations = "RESIZE"
      config.default_cursor_style = "BlinkingBlock"
      config.cursor_blink_ease_in = 'Constant'
      config.cursor_blink_ease_out = 'Constant'
      config.cursor_blink_rate = 800
      -- config.font = wezterm.font({ family = 'JetBrains Mono' })
      config.font_size = 10
      config.window_frame = {
        font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
        font_size = 10,
      }
end

return M