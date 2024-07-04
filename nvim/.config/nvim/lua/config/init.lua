vim.o.formatoptions = "cqrn1"
vim.o.number = true
vim.o.numberwidth = 4
vim.o.paste = false
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.textwidth = 0
vim.o.wrapmargin = 0
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.swapfile = true
vim.cmd([[
  set signcolumn=yes
  set conceallevel=1
]])

-- search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

-- autoindent
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.shiftround = false

-- stop removing the new line at the end of files!
vim.o.eol = true
vim.o.fixeol = false

-- aesthetics
vim.opt.list = true
-- vim.opt.listchars = "eol:󰘌,nbsp:+,space:⋅,tab: ,trail:-"
vim.opt.listchars = "nbsp:+,space:⋅,tab:󰇘 ,trail:-"
-- vim.opt.listchars = "nbsp:+,space:⋅,tab:󰇘 ,trail:-,eol:↴"
-- vim.opt.listchars = "eol:↴,nbsp:+,space:⋅,tab: ,trail:-"
-- vim.opt.listchars = "eol:󰌑,nbsp:+,space:⋅,tab: ,trail:-"
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
-- vim.opt.listchars.tab = " "

-- mouse
vim.o.mouse = "a"

-- directory settings
vim.o.directory = os.getenv("HOME") .. "/.vim/tmp/"

-- highlight the yanking
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}]])

vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.termguicolors = true

vim.cmd([[
augroup JsonnetFiles
  autocmd!
  autocmd BufReadPre *.jsonnet setfiletype jsonnet
  autocmd BufReadPre *.libsonnet setfiletype jsonnet
augroup END
]])

-- create the autocmd for obsidian files
-- local homedir = os.getenv("HOME")
-- local obsidiandir = homedir .. "/Library/Mobile Documents/iCloud~md~obsidian/"
local obsidianre = "iCloud~md~obsidian"
vim.api.nvim_create_autocmd({
  "BufNewFile",
  "BufRead",
}, {
  pattern = "*.md",
  group = vim.api.nvim_create_augroup("Obsidian", { clear = true }),
  callback = function(ev)
    -- extract the dirname
    local dirname = vim.fn.fnamemodify(ev.file, ":h")
    local lookup = string.find(dirname, obsidianre, 1, true)
    if lookup ~= nil then
      vim.api.nvim_buf_set_option(ev.buf, "filetype", "markdown_obsidian")
      vim.treesitter.start(0, "markdown")
    end
  end,
})
