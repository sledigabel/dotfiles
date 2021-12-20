-- general
vim.o.colorcolumn = "80"
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

-- mouse
vim.o.mouse = "a"

-- highlight the yanking
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}]]


vim.api.nvim_set_keymap("n", "<leader>y", '"*y', { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>y", '"*y', { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>caw", '<cmd>lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false) end end<cr>', { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>d", ':bd<cr>', { noremap = true })
vim.o.directory = "/Users/sebastienledigabel/.vim/tmp/"

-- copy the current line and comment
vim.api.nvim_set_keymap("n", "<leader>/", "<cmd>normal yyPgccj<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<lt>", "<lt>gv", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true })

-- CTRL-E
vim.api.nvim_set_keymap("i", "<C-e>", "<Esc>A", { noremap = true })




