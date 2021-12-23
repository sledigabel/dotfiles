local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		initial_mode = "insert",
		color_devicons = true,

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
		file_ignore_patterns = { ".git" },
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

vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>f.",
	"<cmd>Telescope find_files hidden=true cwd=~/.config/nvim find_command=fd,-e,lua<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>ff",
	"<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>fa",
	"<cmd>lua require('telescope.builtin').live_grep({hidden=true})<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>fo",
	"<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
	{ noremap = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>ti",
	"<cmd>lua require('telescope').extensions.gh.issues()<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>tp",
	"<cmd>lua require('telescope').extensions.gh.pull_requests()<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua require('telescope').extensions.gh.gist()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ta", "<cmd>lua require('telescope').extensions.gh.run()<cr>", { noremap = true })

-- " yanking highlights
-- augroup highlight_yank
--     autocmd!
--     au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=400}
-- augroup END
--
-- " close all windows
-- nnoremap <leader>caw <cmd>lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false); print('Closing window', win) end end<cr>
--
-- nnoremap <leader>ti <cmd>lua require('telescope').extensions.gh.issues()<cr>
-- nnoremap <leader>tp <cmd>lua require('telescope').extensions.gh.pull_request()<cr>
-- nnoremap <leader>tg <cmd>lua require('telescope').extensions.gh.gist()<cr>
-- nnoremap <leader>ta <cmd>lua require('telescope').extensions.gh.run()<cr>
