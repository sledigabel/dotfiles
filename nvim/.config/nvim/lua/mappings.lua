-- nmap <C-s> :w<CR>
-- imap <C-s> <Esc>:w<CR>


vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {})
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", {})

