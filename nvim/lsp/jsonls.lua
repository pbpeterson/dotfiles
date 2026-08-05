-- JSON Language Server (vscode-langservers-extracted)
-- Schema-aware completion/validation for package.json, tsconfig.json, etc.
-- Schemas come from SchemaStore.nvim (data-only plugin, loads on this require).

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      format = { enable = true },
      validate = { enable = true },
    },
  },
}
