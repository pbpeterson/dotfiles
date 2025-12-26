-- Centralized LSP keymaps
-- These keymaps are shared across multiple LSP servers

local M = {}

-- Common TypeScript/JavaScript LSP keymaps (for both VTsls and Deno)
M.typescript_common = {
  {
    "gD",
    function()
      vim.lsp.buf.definition()
    end,
    desc = "Goto Definition",
  },
  {
    "gR",
    function()
      vim.lsp.buf.references()
    end,
    desc = "References",
  },
  {
    "<leader>co",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
    end,
    desc = "Organize Imports",
  },
  {
    "<leader>cD",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.fixAll" },
          diagnostics = {},
        },
      })
    end,
    desc = "Fix all diagnostics",
  },
}

-- VTsls-specific keymaps
M.vtsls_specific = {
  {
    "gD",
    function()
      local params = vim.lsp.util.make_position_params()
      LazyVim.lsp.execute({
        command = "typescript.goToSourceDefinition",
        arguments = { params.textDocument.uri, params.position },
        open = true,
      })
    end,
    desc = "Goto Source Definition",
  },
  {
    "gR",
    function()
      LazyVim.lsp.execute({
        command = "typescript.findAllFileReferences",
        arguments = { vim.uri_from_bufnr(0) },
        open = true,
      })
    end,
    desc = "File References",
  },
  {
    "<leader>co",
    LazyVim.lsp.action["source.organizeImports"],
    desc = "Organize Imports",
  },
  {
    "<leader>cM",
    LazyVim.lsp.action["source.addMissingImports.ts"],
    desc = "Add missing imports",
  },
  {
    "<leader>cu",
    LazyVim.lsp.action["source.removeUnused.ts"],
    desc = "Remove unused imports",
  },
  {
    "<leader>cD",
    LazyVim.lsp.action["source.fixAll.ts"],
    desc = "Fix all diagnostics",
  },
  {
    "<leader>cV",
    function()
      LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
    end,
    desc = "Select TS workspace version",
  },
}

-- Deno-specific keymaps
M.deno_specific = {
  {
    "<leader>dc",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.cache" },
          diagnostics = {},
        },
      })
    end,
    desc = "Cache Dependencies",
  },
}

return M
