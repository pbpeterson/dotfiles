-- Debugging Adapter Protocol (DAP) Configuration
-- Centralized debugging setup for TypeScript/JavaScript and Deno

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, {
            "js-debug-adapter",
            "deno",
          })
        end,
      },
    },
    config = function()
      local dap = require("dap")

      -- Node.js / TypeScript Adapter (pwa-node)
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              LazyVim.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
              "${port}",
            },
          },
        }
      end

      -- Node adapter (alias for pwa-node)
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      -- Deno Adapter
      if not dap.adapters["deno"] then
        dap.adapters["deno"] = {
          type = "executable",
          command = "deno",
          args = { "run", "--inspect-wait", "--allow-all" },
        }
      end

      -- Define filetypes for JavaScript/TypeScript
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      -- Register vscode types
      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      -- Configure debugging for each filetype
      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {}
        end

        -- Node.js configurations
        vim.list_extend(dap.configurations[language], {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Node.js file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node.js",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        })

        -- Deno configurations
        vim.list_extend(dap.configurations[language], {
          {
            type = "deno",
            request = "launch",
            name = "Launch Deno file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "deno",
            runtimeArgs = { "run", "--inspect-wait", "--allow-all" },
            attachSimplePort = 9229,
          },
          {
            type = "deno",
            request = "attach",
            name = "Attach to Deno",
            cwd = "${workspaceFolder}",
            attachSimplePort = 9229,
          },
        })
      end
    end,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue" },
      { "<leader>di", "<cmd>DapStepInto<CR>", desc = "Step Into" },
      { "<leader>do", "<cmd>DapStepOver<CR>", desc = "Step Over" },
      { "<leader>dO", "<cmd>DapStepOut<CR>", desc = "Step Out" },
      { "<leader>dt", "<cmd>DapTerminate<CR>", desc = "Terminate" },
      { "<leader>dr", "<cmd>DapToggleRepl<CR>", desc = "Toggle REPL" },
    },
  },

  -- DAP UI for a better debugging experience
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- Virtual text support for DAP
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      virt_text_pos = "eol",
    },
  },
}
