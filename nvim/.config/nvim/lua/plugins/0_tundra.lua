return {
  {
    "sam4llis/nvim-tundra",
    config = function()
      require("nvim-tundra").setup({
        transparent_background = true,
        plugins = {
          lsp = true,
          treesitter = true,
          nvimtree = true,
          cmp = true,
          context = true,
          gitsigns = true,
          telescope = true,
        },
      })

      if vim.g.theme == "tundra" then
        vim.cmd("colorscheme tundra")
      end
    end,
    priority = 100,
    lazy = false,
    enabled = true,
  },
}
