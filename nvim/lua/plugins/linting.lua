-- Linting Configuration
-- Uses oxlint when .oxlintrc.json is present, otherwise eslint_d

local constants = require("config.constants")

local js_linters = { "oxlint", "eslint_d" }

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      -- Both linters listed; conditions control which one runs
      linters_by_ft = {
        markdown = {}, -- Disable markdownlint warnings
        javascript = js_linters,
        javascriptreact = js_linters,
        typescript = js_linters,
        typescriptreact = js_linters,
        svelte = js_linters,
        vue = js_linters,
      },
      linters = {
        -- Configure markdownlint to ignore line length
        markdownlint = {
          args = {
            "--disable",
            "MD013", -- Line length rule
            "MD041", -- First line in file should be a top level header
            "--",
          },
        },
        -- oxlint: only runs when .oxlintrc.json is found
        oxlint = {
          condition = function(ctx)
            return constants.is_oxlint_project(ctx.dirname)
          end,
        },
        -- eslint_d: only runs when .oxlintrc.json is NOT found
        eslint_d = {
          condition = function(ctx)
            return not constants.is_oxlint_project(ctx.dirname)
          end,
          args = {
            "--no-warn-ignored",
            "--format",
            "json",
            "--stdin",
            "--stdin-filename",
            function()
              return vim.api.nvim_buf_get_name(0)
            end,
          },
        },
      },
    },
  },
}
