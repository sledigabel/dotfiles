return {
  "lewis6991/hover.nvim",
  dependencies = {
    "/Users/sebastienledigabel/dev/work/nvim-travelapi/",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("hover").setup({
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        require("hover.providers.jira")
      end,
      preview_opts = {
        border = "double",
      },
    })

    local TRAVEL_API_PATTERN = "[%d]+"

    local function enabled()
      return vim.fn.expand("<cword>"):match(TRAVEL_API_PATTERN) ~= nil
    end

    local function execute(opts, done)
      local query = vim.fn.expand("<cword>"):match(TRAVEL_API_PATTERN)

      local output = require("travelapi").travelapi(query)
      if output ~= nil then
        done({ lines = output, filetype = "markdown" })
      else
        done()
      end
    end

    require("hover").register({
      name = "TravelAPI",
      priority = 10,
      enabled = enabled,
      execute = execute,
    })
  end,
}
