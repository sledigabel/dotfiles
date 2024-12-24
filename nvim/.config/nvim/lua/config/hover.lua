require("hover").setup({
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.gh")
        require("hover.providers.gh_user")
        require("hover.providers.jira")
      end,
      preview_opts = {
        border = "rounded",
      },
    })

    -- travel-api
    local TRAVEL_API_PATTERN = "[%d]+"

    local function tapi_enabled()
      return vim.fn.expand("<cword>"):match(TRAVEL_API_PATTERN) ~= nil
    end

    local function tapi_execute(opts, done)
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
      priority = 1000,
      enabled = tapi_enabled,
      execute = tapi_execute,
    })

    -- accounts
    local path = os.getenv("HOME") .. "/dev/work/account-config/config/"
    -- local ACCOUNT_PATTERN = "[%d]+"
    local ACCOUNT_PATTERN = "%d%d%d%d%d%d%d%d%d%d%d%d"
    -- local ACCOUNT_PATTERN = [[\d{12}]]

    local function account_enabled()
      return vim.fn.expand("<cword>"):match(ACCOUNT_PATTERN) ~= nil
    end

    local function account_execute(opts, done)
      local query = vim.fn.expand("<cword>"):match(ACCOUNT_PATTERN)

      -- check if account exists
      if not vim.fn.filereadable(path .. query .. ".yml") then
        done()
      end

      -- open the file and read the account name
      local output = {}
      local lines = vim.fn.readfile(path .. query .. ".yml")
      for _, line in ipairs(lines) do
        if line == "Defaults:" then
          -- from my empirical checks, nothing is ever interesting after this section
          break
        end
        -- we only keep one level of nesting, otherwise too verbose
        if #line >= 4 and line:sub(1, 4) ~= "    " then
          table.insert(output, line)
        end
      end

      if #output == 0 then
        done()
      end

      done({ lines = output, filetype = "yaml" })
    end

    require("hover").register({
      name = "AWS Account",
      priority = 10001,
      enabled = account_enabled,
      execute = account_execute,
    })
