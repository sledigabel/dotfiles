-- return {}
return {
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" }, config = true },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DapUIBreakpointsInfo",
        linehl = "DapUIBreakpointsInfo",
        numhl = "DapUIBreakpointsInfo",
      })
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapUIStop", linehl = "DapUIStop", numhl = "DapUIStop" }
      )

      dapui.setup({})
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end
    end,
    lazy = true,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dappython = require("dap-python")
      dappython.setup("~/.pyenv/shims/python")
      dappython.test_runner = "pytest"
    end,
    -- lazy = true,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 1044,
        },
      }
    end,
  },
}
