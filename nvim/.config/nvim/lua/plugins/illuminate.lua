return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
      },
    })
  end,
}
