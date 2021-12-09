local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Webdevicons
  use { 'kyazdani42/nvim-web-devicons' }

  -- Tree sitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'nvim-telescope/telescope-github.nvim' }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Surround
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require"surround".setup {mappings_style = "surround", map_insert_mode = false}
    end
  }
  -- TMUX
  use { "aserowy/tmux.nvim",
        config = function()
          require("tmux").setup({
            copy_sync = {
                enable = false,
                redirect_to_clipboard = false,
                sync_clipboard = false,
                sync_unnamed = false,
            },
            navigation = {
                -- enables default keybindings (C-hjkl) for normal mode
                enable_default_keybindings = true,
            },
            resize = {
                -- enables default keybindings (A-hjkl) for normal mode
                enable_default_keybindings = true,
            }
        })
      end
    }

  -- Themes
  use { 'Mofiqul/vscode.nvim' }

  -- bootstrapping packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)


