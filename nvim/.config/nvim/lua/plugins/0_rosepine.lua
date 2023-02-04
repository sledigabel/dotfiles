return {
  "rose-pine/neovim",
  config = function()
    if vim.g.theme == "rose-pine" then
      vim.cmd([[ colorscheme rose-pine ]])
    end
  end
}
