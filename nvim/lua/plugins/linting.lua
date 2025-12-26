-- Linting Configuration
-- Customizes linter behavior to reduce noise

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      -- Linters by filetype
      linters_by_ft = {
        markdown = {}, -- Disable markdownlint warnings
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        vue = { "eslint_d" },
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
        -- eslint_d for faster linting (daemon version of eslint)
        eslint_d = {
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
