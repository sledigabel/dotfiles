return {
  "folke/tokyonight.nvim",
  config = function()
    if vim.g.theme == "tokyonight" then
      vim.cmd([[ colorscheme tokyonight ]])
    end
  end,
}
