require("hover").config({
  providers = {
    "hover.providers.diagnostic",
    "hover.providers.lsp",
    "hover.providers.gh",
    "hover.providers.gh_user",
    "hover.providers.jira",
    "travelapi.hover",
  },
  preview_opts = {
    border = "rounded",
  },
})

-- Custom AWS Account provider
local M = {}

local path = os.getenv("HOME") .. "/dev/work/account-config/config/"
local ACCOUNT_PATTERN = "%d%d%d%d%d%d%d%d%d%d%d%d"

local function account_enabled(bufnr)
  return vim.fn.expand("<cword>"):match(ACCOUNT_PATTERN) ~= nil
end

local function account_execute(params, done)
  local query = vim.fn.expand("<cword>"):match(ACCOUNT_PATTERN)

  -- check if account exists
  if not vim.fn.filereadable(path .. query .. ".yml") then
    done()
    return
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
    return
  end

  done({ lines = output, filetype = "yaml" })
end

-- Register custom provider using the new API
M.aws_account_provider = {
  name = "AWS Account",
  priority = 10001,
  enabled = account_enabled,
  execute = account_execute,
}

-- Add to hover providers if hover is loaded
local ok, hover = pcall(require, "hover")
if ok then
  -- This is a workaround to add custom provider at runtime
  -- Ideally this would be a separate module in lua/hover/providers/
  vim.defer_fn(function()
    local providers = hover._providers or {}
    table.insert(providers, M.aws_account_provider)
  end, 100)
end

return M
