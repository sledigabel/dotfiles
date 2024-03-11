local icloud_path = os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/"

return {
  "epwalsh/obsidian.nvim",
  -- version = "*", -- recommended, use latest release instead of latest commit
  -- lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianToday",
    "ObsidianTomorrow",
    "ObsidianSearch",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "Work",
        path = icloud_path .. "Work",
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "notes/impacts",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      min_chars = 2,
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
    finder = "telescope.nvim",

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local prefix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        prefix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-_)]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          prefix = prefix .. string.char(math.random(65, 90))
        end
      end
      -- return tostring(os.time()) .. "-" .. suffix
      return prefix .. tostring(os.date("%Y-%m-%d"))
    end,
  },
}
