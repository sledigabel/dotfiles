return {
  {
    "shaunsingh/nord.nvim",
    config = function()
      if vim.g.theme == "nord" then
        vim.cmd("colorscheme nord")
      end
    end,
    priority = 100,
    lazy = false,
    enabled = true,
  },
}
