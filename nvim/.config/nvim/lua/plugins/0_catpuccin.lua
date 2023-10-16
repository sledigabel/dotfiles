return {
  "catppuccin/nvim",
  name = "catppuccin",
  config = function()
    local catppuccin = require("catppuccin")
    catppuccin.setup({
      transparent_background = true,
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
        },
        cmp = true,
        lsp_saga = true,
        gitsigns = true,
        telescope = true,
        nvimtree = {
          enabled = true,
          show_root = true,
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        which_key = true,
        markdown = true,
      },
      custom_highlights = function(colors)
        return {
          Whitespace = { fg = "#3B3B3B"},
        }
      end
    })
    -- vim.g.catppuccin_flavour = "macchiato"
    -- vim.g.catppuccin_flavour = "moccha"
    vim.g.catppuccin_flavour = "frappe"

    if vim.g.theme == "catpuccin" then
      vim.cmd([[ colorscheme catppuccin ]])
    end
  end,
  enabled = true,
}
