-- TailwindCSS LSP Configuration
-- Provides autocomplete and IntelliSense for TailwindCSS classes
-- Includes support for Phoenix/Elixir .heex templates

return {
  opts = {
    filetypes_exclude = { "markdown" },
    filetypes_include = { "typescriptreact", "javascriptreact" },
  },
  setup = function(_, opts)
    local lspconfig = require("lspconfig")

    -- Get default filetypes from lspconfig
    local default_filetypes = lspconfig.tailwindcss.document_config.default_config.filetypes or {}

    opts.filetypes = opts.filetypes or {}

    -- Add default filetypes
    vim.list_extend(opts.filetypes, default_filetypes)

    -- Remove excluded filetypes
    opts.filetypes = vim.tbl_filter(function(ft)
      return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
    end, opts.filetypes)

    -- Additional settings for Phoenix projects
    opts.settings = opts.settings or {}
    opts.settings.tailwindCSS = opts.settings.tailwindCSS or {}
    opts.settings.tailwindCSS.includeLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    }

    -- Add additional filetypes
    vim.list_extend(opts.filetypes, opts.filetypes_include or {})
  end,
}