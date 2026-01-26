local icloud_path = os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/"

local opts = {
  legacy_commands = false,
  workspaces = {
    {
      name = "Work",
      path = icloud_path .. "Work",
    },
  },
  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    -- folder = "notes/impacts",
    folder = "notes/dailies",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "daily-template.md",
  },

  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
  },

  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    min_chars = 2,
    create_new = true,
  },

  picker = {
    name = "snacks.pick",
  },

  image_name_func = function()
    return "Pasted_image_" .. tostring(os.date("%Y%m%d%H%M%S"))
  end,

  attachments = {
    folder = "attachments",
    confirm_img_paste = false,
  },
}

require("obsidian").setup(opts)

local wk = require("which-key")
wk.add({
  mode = "n",
  -- Obsidian
  { "<leader>O", group = "Obsidian", remap = false },
  { "<leader>On", "<cmd>Obsidian new<cr>", desc = "New file in Obsidian", remap = false },
})

wk.add({
  mode = "i",
  {
    "<C-P>",
    function()
      if vim.bo.filetype == "markdown_obsidian" then
        local cr_key = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
        local escape_key = vim.api.nvim_replace_termcodes("<escape>", true, false, true)
        vim.api.nvim_feedkeys(cr_key, "n", false)
        vim.api.nvim_feedkeys(cr_key, "n", false)
        vim.api.nvim_feedkeys(escape_key, "n", false)
        vim.api.nvim_feedkeys("k", "n", false)
        vim.api.nvim_feedkeys(":ObsidianPasteImg", "n", false)
        vim.api.nvim_feedkeys(cr_key, "n", false)
        vim.api.nvim_feedkeys("jo", "n", false)
      end
    end,
    desc = "Paste Image",
    remap = false,
  },
})
