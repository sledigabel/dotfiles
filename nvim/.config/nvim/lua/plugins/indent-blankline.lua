return {
  {
    enabled = false,
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      --
      local highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      }
      --
      -- local hooks = require("ibl.hooks")
      -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterRed", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", {})
      --   vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", {})
      -- end)
      require("ibl").setup({
        scope = {
          highlight = highlight,
          show_exact_scope = true,
        },
        -- show_end_of_line = true,
        -- space_char_blankline = " ",
      })
    end,
  },
}
