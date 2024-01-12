return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = {}, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },

          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["[c"] = "@class.outer",
              ["[f"] = "@function.outer",
            },
            goto_previous_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
}
