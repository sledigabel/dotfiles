return {
  "rcarriga/nvim-notify",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("notify").setup({
      background_colour = "#000000",
      timeout = 500,
      top_down = false,
      render = "compact",
    })

    -- vim.cmd([[ highlight link NotifyBackground Normal ]])
    vim.notify = require("notify")

    -- local client_notifs = {}
    --
    -- local function init_notif_data(client_id, token)
    --   if not client_notifs[client_id] then
    --     client_notifs[client_id] = {}
    --   end
    --   if not client_notifs[client_id][token] then
    --     client_notifs[client_id][token] = {}
    --   end
    --   return client_notifs[client_id][token]
    -- end
    --
    -- local function get_notif_data(client_id, token)
    --   if not client_notifs[client_id] or not client_notifs[client_id][token] then
    --     return nil
    --   end
    --
    --   return client_notifs[client_id][token]
    -- end
    --
    -- local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    --
    -- local function update_spinner(client_id, token)
    --   local notif_data = get_notif_data(client_id, token)
    --
    --   if notif_data and notif_data.spinner then
    --     local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    --     notif_data.spinner = new_spinner
    --
    --     notif_data.notification = vim.notify(nil, nil, {
    --       hide_from_history = true,
    --       icon = spinner_frames[new_spinner],
    --       replace = notif_data.notification,
    --     })
    --
    --     vim.defer_fn(function()
    --       update_spinner(client_id, token)
    --     end, 100)
    --   end
    -- end
    --
    -- local function format_title(title, client_name)
    --   return client_name .. (#title > 0 and ": " .. title or "")
    -- end
    --
    -- local function format_message(message, percentage)
    --   return (percentage and percentage .. "%\t" or "") .. (message or "")
    -- end

    --
    --  _
    -- | |___ _ __    _ __ ___   ___  ___ ___  __ _  __ _  ___  ___
    -- | / __| '_ \  | '_ ` _ \ / _ \/ __/ __|/ _` |/ _` |/ _ \/ __|
    -- | \__ \ |_) | | | | | | |  __/\__ \__ \ (_| | (_| |  __/\__ \
    -- |_|___/ .__/  |_| |_| |_|\___||___/___/\__,_|\__, |\___||___/
    --       |_|                                    |___/

    --   vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    --     local client_id = ctx.client_id
    --
    --     local val = result.value
    --
    --     if not val.kind then
    --       return
    --     end
    --
    --     if val.kind == "begin" and val.title ~= "formatting" and val.title ~= "format" then
    --       vim.pretty_print(val)
    --
    --       local notif_data = init_notif_data(client_id, result.token)
    --
    --       local message = format_message(val.message, val.percentage)
    --       notif_data.notification = vim.notify(message, "info", {
    --         title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
    --         icon = spinner_frames[1],
    --         timeout = false,
    --         hide_from_history = false,
    --       })
    --
    --       notif_data.spinner = 1
    --       update_spinner(client_id, result.token)
    --     elseif val.kind == "report" then
    --       local notif_data = get_notif_data(client_id, result.token)
    --       if notif_data then
    --         notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
    --           replace = notif_data.notification,
    --           hide_from_history = true,
    --         })
    --       end
    --     elseif val.kind == "end" then
    --       local notif_data = get_notif_data(client_id, result.token)
    --       if notif_data then
    --         notif_data.notification =
    --         vim.notify(val.message and format_message(val.message) or "Complete", "info", {
    --           icon = "",
    --           replace = notif_data.notification,
    --           timeout = 1000,
    --         })
    --         notif_data.spinner = nil
    --       end
    --     end
    --   end
  end,
}
