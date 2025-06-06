local actions = require("telescope.actions")

local sorters = require("telescope.sorters")

-- My special sorting, I like my test files to show last
local special_test_sorter = function(opts)
  opts = opts or {}
  local fzy = opts.fzy_mod or require("telescope.algos.fzy")
  local OFFSET = -fzy.get_score_floor()

  return sorters.Sorter:new({
    discard = true,

    -- strongly inspired from telescope's default file sorter
    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/sorters.lua#L438
    scoring_function = function(sorter, prompt, line)
      if not fzy.has_match(prompt, line) then
        return -1
      end

      local fzy_score = fzy.score(prompt, line)

      if fzy_score == fzy.get_score_min() then
        return 1
      end

      local test_file_weight = 0
      if
        (string.find(line, "Test") or string.find(line, "test"))
        and (not string.find(prompt, "test") and not string.find(prompt, "Test"))
      then
        -- could be any positive value, taking a low value to ensure the test files offset
        test_file_weight = 1
      end
      return 1 / (fzy_score + OFFSET - test_file_weight)
    end,

    -- The fzy.positions function, which returns an array of string indices, is
    -- compatible with telescope's conventions. It's moderately wasteful to
    -- call call fzy.score(x,y) followed by fzy.positions(x,y): both call the
    -- fzy.compute function, which does all the work. But, this doesn't affect
    -- perceived performance.
    highlighter = function(_, prompt, display)
      return fzy.positions(prompt, display)
    end,
  })
end

require("telescope").setup({
  defaults = {
    layout_strategy = "horizontal",
    initial_mode = "insert",
    color_devicons = true,
    path_display = { "smart" },

    file_sorter = special_test_sorter,
    -- file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " > ",
    set_env = { ["COLORTERM"] = "truecolor" },

    -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

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
        -- ["<C-q>"] = actions.send_selected_to_qflist,
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

-- key bindings
local wk = require("which-key")
wk.add({
  mode = "n",
  -- { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers", remap = false },
  --
  { "<leader>f", group = "Telescope", remap = false },
  -- {
  --   "<leader>f.",
  --   "<cmd>Telescope find_files hidden=true cwd=~/.config/nvim no_ignore=true find_command=fd,-e,lua<cr>",
  --   desc = "Neovim files",
  --   remap = false,
  -- },
  -- {
  --   "<leader>fa",
  --   "<cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>",
  --   desc = "Grep files",
  --   remap = false,
  -- },
  { "<leader>fc", require("telescope").extensions.gh.gist, desc = "Gists", remap = false },
  -- {
  --   "<leader>ff",
  --   "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>",
  --   desc = "Find files",
  --   remap = false,
  -- },
  {
    "<leader>fi",
    require("telescope").extensions.gh.issues,
    desc = "Github issues",
    remap = false,
  },
  {
    "<leader>fo",
    require("telescope.builtin").lsp_document_symbols,
    desc = "Symbols",
    remap = false,
  },
  {
    "<leader>fp",
    require("telescope").extensions.gh.pull_requests,
    desc = "Pull requests",
    remap = false,
  },
  -- {
  --   "<c-p>",
  --   require("telescope.builtin").git_files,
  --   desc = "Git files",
  --   remap = false,
  -- },
})
