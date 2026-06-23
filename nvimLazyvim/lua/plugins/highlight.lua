return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        hl["@markup.strong"] = { fg = c.orange, bold = true, underline = false, italic = false }
      end,
    },
  },
}
