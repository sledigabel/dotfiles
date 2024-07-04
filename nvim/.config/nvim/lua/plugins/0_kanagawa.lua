return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({})
		if vim.g.theme == "kanagawa" or vim.g.theme == "kanagawa-lotus" then
			vim.cmd("colorscheme kanagawa")
		end
	end,
}
