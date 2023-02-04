return {
  "ellisonleao/gruvbox.nvim",
  enable = true,
  config = function()
    if vim.g.theme == "gruvbox" then
      vim.cmd([[ colorscheme gruvbox ]])
    end
  end
}
