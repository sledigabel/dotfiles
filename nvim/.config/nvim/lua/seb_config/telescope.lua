local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    layout_strategy = "horizontal",
    initial_mode = "insert",
    color_devicons = true,
    path_display = { "smart" },

    file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " > ",
    set_env = { ["COLORTERM"] = "truecolor" },

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    vimgrep_arguments = {
      "rg",
      "--vimgrep",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
      "--hidden",
    },
    -- file_ignore_patterns = { ".git" },
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist,
        ["<esc>"] = actions.close,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("gh")
require('telescope').load_extension('dap')
