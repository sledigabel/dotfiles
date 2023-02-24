return {
  "RRethy/vim-illuminate",
  event = "BufReadPre",
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
