-- LSP Configuration
-- Central configuration for Language Server Protocol
-- Loads individual LSP configs from lua/plugins/lsp/ directory

local constants = require("config.constants")

-- Select formatter for JS/TS: Deno > oxfmt > prettier
local function ts_formatter()
  if constants.is_deno_project() then
    return { "deno_fmt" }
  end
  if constants.is_oxfmt_project() then
    return { "oxfmt" }
  end
  return { "prettier" }
end

-- Select formatter for web filetypes: oxfmt > prettier
local function web_formatter()
  if constants.is_oxfmt_project() then
    return { "oxfmt" }
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
        -- Disable eslint LSP since we're using eslint_d/oxlint
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
        "oxfmt",
        "stylua", -- Lua formatter
        -- Linters (daemon versions for better performance)
        "eslint_d",
        "oxlint",
      },
    },
  },

  -- Conform formatter with Deno/oxfmt/Node.js auto-detection
  -- opts is a function so require("conform.util") is deferred until conform loads
  -- (a table literal forces conform + mason onto the startup path; ~6ms saved).
  {
    "stevearc/conform.nvim",
    opts = function()
      return {
        formatters_by_ft = {
          typescript = ts_formatter,
          typescriptreact = ts_formatter,
          javascript = ts_formatter,
          javascriptreact = ts_formatter,
          lua = { "stylua" },
          json = web_formatter,
          yaml = web_formatter,
          markdown = web_formatter,
          html = web_formatter,
          css = web_formatter,
          scss = web_formatter,
          svelte = web_formatter,
          vue = web_formatter,
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
          oxfmt = {
            command = "oxfmt",
            args = { "--stdin-filepath", "$FILENAME" },
            stdin = true,
            cwd = require("conform.util").root_file({ ".oxfmtrc.json" }),
          },
        },
      }
    end,
  },

  -- TailwindCSS color preview in completion menu.
  -- Disabled: blink.cmp (not nvim-cmp) is used, so its formatter hook never runs;
  -- this only loaded eagerly at startup for nothing.
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    enabled = false,
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
