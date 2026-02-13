-- LSP Configuration
-- Central configuration for Language Server Protocol
-- Loads individual LSP configs from lua/plugins/lsp/ directory

local constants = require("config.constants")

-- Select formatter based on Deno vs Node.js project
local function ts_formatter()
  if constants.is_deno_project() then
    return { "deno_fmt" }
  end
  return { "prettier" }
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        -- Disable eslint LSP since we're using eslint_d
        eslint = false,
        tailwindcss = require("plugins.lsp.tailwindcss").opts,
        denols = require("plugins.lsp.denols").opts,
        vtsls = require("plugins.lsp.vtsls").opts,
      },
      setup = {
        tailwindcss = require("plugins.lsp.tailwindcss").setup,
        vtsls = require("plugins.lsp.vtsls").setup,
      },
    },
  },

  -- Mason package manager for LSP servers
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "deno",
        "tailwindcss-language-server",
        -- Formatters (daemon versions for better performance)
        "prettierd",
        "stylua", -- Lua formatter
        -- Linters (daemon versions for better performance)
        "eslint_d",
      },
    },
  },

  -- Conform formatter with Deno/Node.js auto-detection
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = ts_formatter,
        typescriptreact = ts_formatter,
        javascript = ts_formatter,
        javascriptreact = ts_formatter,
        lua = { "stylua" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        svelte = { "prettier" },
        vue = { "prettier" },
      },
      formatters = {
        -- Use prettierd (daemon version) for faster prettier formatting
        prettier = {
          command = "prettierd",
          -- Ensure prettierd restarts when switching projects
          cwd = require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
            "package.json",
          }),
        },
        deno_fmt = {
          command = "deno",
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    },
  },

  -- TailwindCSS color preview in completion menu
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {},
  },

  -- Disable snippets (LSP completions are sufficient)
  { "rafamadriz/friendly-snippets", enabled = false },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "buffer" },
        providers = {
          snippets = { enabled = false },
        },
        -- Filter out snippet-kind completions from LSP
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= 15 -- 15 = Snippet
          end, items)
        end,
      },
    },
  },
}
