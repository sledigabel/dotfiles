-- local mod_theme = require("lualine.themes.auto")
-- local global_background = mod_theme.inactive.c.bg

local tundra_theme = require("lualine.themes.tundra")

local cp = require('nvim-tundra.palette.' .. vim.g.tundra_biome)

tundra_theme.normal = {
  a = { fg = cp.indigo._900, bg = cp.indigo._500, gui = 'bold' },
  b = { fg = cp.indigo._500, bg = cp.transparent, gui = 'bold' },
  c = { fg = cp.indigo._300, bg = cp.transparent },
}

-- print(global_background)
-- mod_theme.normal.b.bg = global_background
-- mod_theme.insert.b.bg = global_background
-- mod_theme.replace.b.bg = global_background
-- mod_theme.visual.b.bg = global_background
-- mod_theme.command.b.bg = global_background
-- mod_theme.normal.b.bg = global_background
-- mod_theme.insert.b.bg = global_background
-- mod_theme.replace.b.bg = global_background
-- mod_theme.visual.b.bg = global_background
-- mod_theme.command.b.bg = global_background

require("lualine").setup({
  options = {
    globalstatus = true,
    theme = tundra_theme,
    -- theme = tundra_theme,
    section_separators = '',
    -- component_separators = '|',
    component_separators = '',
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      -- { 'mode', separator = { left = '', right = '' }, right_padding = 2, }
      { 'mode', right_padding = 2, }
    },
    lualine_b = {
      {
        "branch",
        -- icon = "",
        icon = "",
        padding = 2,
      },
      {
        "diff",
        symbols = { added = ' ', modified = '柳', removed = ' ' },
        padding = 2,
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic", "nvim_lsp" },
        symbols = {
          error = " ",
          warn = " ",
          hint = " ",
          info = " ",
        },
      },
      {
        "filename",
        file_status = true, -- Displays file status (readonly status, modified status)
        path = 0, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path

        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
        symbols = {
          modified = " ", -- Text to show when the file is modified.
          readonly = " ", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
        },
      },
    },
    lualine_c = {
    },
    lualine_x = { "filetype", "progress" },
    lualine_y = {},
    -- lualine_z = { { "location", separator = { left = '' } } },
    lualine_z = { { "location" } },
  },
})

vim.o.winbar = "     %-50(%#BufferLineHintSelected#%{%v:lua.require'nvim-navic'.get_location()%}%)"
