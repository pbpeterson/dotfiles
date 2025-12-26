-- Deno Language Server Configuration
-- Provides TypeScript/JavaScript support for Deno runtime projects
-- Activated only when deno.json or deno.jsonc is present
-- Features: Inlay hints, auto-imports, dependency caching, code lens

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        denols = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function(...)
            return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(...)
          end,
          single_file_support = false,
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
                referencesAllFunctions = true,
              },
            },
          },
          -- Use centralized keymaps from config/lsp-keymaps.lua
          keys = vim.list_extend(
            vim.deepcopy(require("config.lsp-keymaps").typescript_common),
            require("config.lsp-keymaps").deno_specific
          ),
        },
      },
      setup = {
        denols = function(_, opts)
          -- Stop denols from attaching to non-Deno buffers
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "denols" then
                local is_deno = vim.fs.find(
                  { "deno.json", "deno.jsonc" },
                  { path = vim.api.nvim_buf_get_name(args.buf), upward = true }
                )[1] ~= nil
                if not is_deno then
                  vim.lsp.stop_client(client.id)
                end
              end
            end,
          })
        end,
      },
    },
  },


  -- File Icons
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        ["deno.json"] = { glyph = "🦕", hl = "MiniIconsGreen" },
        ["deno.jsonc"] = { glyph = "🦕", hl = "MiniIconsGreen" },
        ["deno.lock"] = { glyph = "🦕", hl = "MiniIconsGreen" },
      },
    },
  },

}
