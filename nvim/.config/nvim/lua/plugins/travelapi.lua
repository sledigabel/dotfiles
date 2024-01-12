return {
  dir = "/Users/sebastienledigabel/dev/work/nvim-travelapi/",
  config = function()
    require("travelapi").setup({})
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
