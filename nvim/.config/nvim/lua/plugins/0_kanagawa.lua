return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({})
		if vim.g.theme == "kanagawa" then
			vim.cmd("colorscheme kanagawa")
		end
	end,
}
