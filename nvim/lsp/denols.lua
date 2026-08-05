-- Deno Language Server
-- Only activates in projects with deno.json/deno.jsonc (workspace_required),
-- so it never fights vtsls over Node projects.

return {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "deno.json", "deno.jsonc" },
  workspace_required = true,
  settings = {
    deno = {
      enable = true,
      unstable = true,
      cache = true,
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
        names = true,
        paths = true,
        imports = {
          autoDiscover = true,
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true,
            ["https://esm.sh"] = true,
          },
        },
      },
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      lint = true,
      codeLens = {
        implementations = true,
        references = true,
        referencesAllFunctions = false,
      },
    },
  },
}
