local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- basic config
vim.g.mapleader = " "
require("config")

local lazyopts = {
  change_detection = {
    -- automatically check for config file changes and reload the ui
    notify = false, -- get a notification when changes are found
  },
}

-- vim.g.theme = "gruvbox"
-- vim.g.theme = "tundra"
vim.g.theme = "kanagawa-lotus"
-- vim.g.theme = "kanagawa"
-- vim.g.theme = "catpuccin"
-- vim.g.theme = "nord"
-- vim.g.theme = "rose-pine"
-- vim.g.theme = "tokyonight"

require("lazy").setup("plugins", lazyopts)
