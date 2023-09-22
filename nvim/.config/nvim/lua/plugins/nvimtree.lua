return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icon
    },
    config = function()
      require("nvim-tree").setup({
        hijack_cursor = true,
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        filters = {
          custom = { "node_modules", ".git", ".idea" },
        },
        view = {
          adaptive_size = true,
          preserve_window_proportions = true,
        },
        renderer = {
          indent_markers = {
            enable = false,
          },
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
    end,
    lazy = true,
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFindFileToggle" },
  },
}
