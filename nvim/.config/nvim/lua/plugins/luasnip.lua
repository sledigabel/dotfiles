return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      -- require('Luasnip').setup({})
      require("luasnip/loaders/from_vscode").lazy_load({
        paths = { "./friendly-snippets" }
      })
    end
  }
}
