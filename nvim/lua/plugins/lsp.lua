-- LSP stack is native now (nvim 0.12): server configs live in <config>/lsp/*.lua,
-- wired by lua/config/lsp.lua via vim.lsp.enable(). This file only disables the
-- old plugin stack and keeps formatting (conform) + completion (blink) tweaks.
-- Binaries are installed by scripts/install-lsp-tools.sh (brew + npm -g).

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
  -- Native LSP replaces the whole nvim-lspconfig/mason stack
  { "neovim/nvim-lspconfig", enabled = false },
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  -- Conform formatter with Deno/oxfmt/Node.js auto-detection
  -- opts is a function so require("conform.util") is deferred until conform loads
  -- (a table literal forces conform onto the startup path; ~6ms saved).
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
            -- Prefer the project-local oxfmt (pinned in package.json) over the
            -- global one, so format-on-save matches `pnpm format` exactly.
            -- A version skew reformats files differently otherwise.
            command = require("conform.util").find_executable(
              { "node_modules/.bin/oxfmt" },
              "oxfmt"
            ),
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
