return {

  cmd = { "markdown-oxide" },
  single_file_support = true,

  root_dir = function()
    return os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/"
  end,
  filetypes = { "markdown_obsidian" },
}
