local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
	function()
		use("wbthomason/packer.nvim")
		use("lewis6991/impatient.nvim")

		-- Webdevicons
		use({ "kyazdani42/nvim-web-devicons" })

		-- Tree sitter
		use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
		use({ "nvim-treesitter/nvim-treesitter-textobjects" })

		-- Telescope
		use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
		use({ "nvim-telescope/telescope-github.nvim" })
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

		-- Surround
		use({
			"blackCauldron7/surround.nvim",
			config = function()
				require("surround").setup({ mappings_style = "surround", map_insert_mode = false })
			end,
		})

		-- Autopairs
		use({ "windwp/nvim-autopairs" })

		-- TMUX
		use({ "aserowy/tmux.nvim" })

		-- Themes
		use({ "Mofiqul/vscode.nvim" })
		use({
			"catppuccin/nvim",
			as = "catppuccin",
		})
		use({ "sainnhe/gruvbox-material" })
		use({ "mhartington/oceanic-next" })

		-- Comment
		use({ "numToStr/Comment.nvim" })

		-- Git signs
		use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
		use({ "ruifm/gitlinker.nvim" })

		-- LSP config
		use({ "neovim/nvim-lspconfig" })
		use({ "ray-x/lsp_signature.nvim" })
		use({ "onsails/lspkind-nvim" })
		-- use { 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' }
		use({ "jose-elias-alvarez/null-ls.nvim" })
		use({ "tjdevries/nlua.nvim" })
		use("tami5/lspsaga.nvim")

		-- Completion
		use({ "hrsh7th/nvim-cmp" })
		use({ "hrsh7th/cmp-path" })
		use({ "hrsh7th/cmp-buffer" })
		use({ "hrsh7th/cmp-calc" })
		use({ "hrsh7th/cmp-emoji" })
		use({ "hrsh7th/cmp-nvim-lsp" })
		use({ "hrsh7th/cmp-nvim-lua" })
		use({ "saadparwaiz1/cmp_luasnip" })

		-- Statusline
		use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

		-- Git
		use({ "tpope/vim-fugitive" })

		-- Formatter
		use({ "mhartington/formatter.nvim" })

		-- Tree
		use({
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons", -- optional, for file icon
			},
		})

		-- Neovim clip
		use({ "AckslD/nvim-neoclip.lua", requires = { { "nvim-telescope/telescope.nvim" } } })

		-- Snips
		use({ "L3MON4D3/LuaSnip" })

		use({ "lukas-reineke/indent-blankline.nvim" })

		use({ "McAuleyPenney/tidy.nvim" })

		-- Zen mode
		use({ "akinsho/bufferline.nvim" })

		-- Which key
		use({ "folke/which-key.nvim" })
		-- bootstrapping packer
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = { compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua" },
})
