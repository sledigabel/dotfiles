return {

  {
    "ur4ltz/surround.nvim",
    event = "InsertEnter",
    config = function()
      require("surround").setup({ mappings_style = "surround", map_insert_mode = false })
    end,
  },
}
