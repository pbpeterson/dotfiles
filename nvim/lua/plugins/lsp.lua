-- LSP Configuration
-- Central configuration for Language Server Protocol
-- Loads individual LSP configs from lua/plugins/lsp/ directory

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
        autotag = require("plugins.lsp.autotag").opts,
        denols = require("plugins.lsp.denols").opts,
        vtsls = require("plugins.lsp.vtsls").opts,
      },
      setup = {
        autotag = require("plugins.lsp.autotag").setup,
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
        "tailwindcss-language-server",
        "emmet-ls",
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
        typescript = function(bufnr)
          if vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true })[1] then
            return { "deno_fmt" }
          end
          return { "prettier" }
        end,
        typescriptreact = function(bufnr)
          if vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true })[1] then
            return { "deno_fmt" }
          end
          return { "prettier" }
        end,
        javascript = function(bufnr)
          if vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true })[1] then
            return { "deno_fmt" }
          end
          return { "prettier" }
        end,
        javascriptreact = function(bufnr)
          if vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true })[1] then
            return { "deno_fmt" }
          end
          return { "prettier" }
        end,
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

  -- Add TailwindCSS colorizer to nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item)
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
