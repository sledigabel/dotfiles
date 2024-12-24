-- local lspstatus = require("lsp-progress")
-- local print_status = function()
--   local ok, msg = pcall(lspstatus.progress)
--   if ok then
--     return msg
--   else
--     return "..."
--   end
-- end

local lualine_theme = "auto"

function CodeCompleteStatus()
  if vim.g.copilot_enabled then
    return " "
  else
    return "  "
  end
end

require("lualine").setup({
  options = {
    globalstatus = true,
    section_separators = "",
    theme = lualine_theme,
    component_separators = "",
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      -- { 'mode', separator = { left = '', right = '' }, right_padding = 2, }
      { "mode", right_padding = 2 },
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
        symbols = { added = " ", modified = "󰏬 ", removed = " " },
        padding = 2,
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic", "nvim_lsp" },
        symbols = {
          error = " ",
          warn = " ",
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
    lualine_c = {},
    lualine_x = {
      -- {
      --   print_status,
      --   always_visible = true,
      --   separator = { left = "", right = "" },
      --   fmt = function(str)
      --     return str:sub(1, 60)
      --   end,
      -- },
      { "CodeCompleteStatus()", padding = 0, always_visible = false, separator = { left = "", right = "" } },
      -- "progress",
    },
    lualine_y = { "filetype" },
    -- lualine_z = { { "location", separator = { left = '' } } },
    lualine_z = {
      { "progress", separator = { left = "", right = "" } },
      -- { "progress" },
      { "location", padding = 0 },
    },
  },
})
