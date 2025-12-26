-- VTsls (Visual Studio TypeScript Language Server) Configuration
-- High-performance TypeScript/JavaScript language server
-- Automatically excludes Deno projects and prioritizes tsconfig.json
-- Features: Inlay hints, auto-imports, organize imports, code actions

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function(filename, bufnr)
            local lspconfig = require("lspconfig")
            -- Explicitly exclude Deno projects
            local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")(filename)
            if denoRootDir then
              return nil
            end
            -- Prioriza o tsconfig.json mais próximo do arquivo
            -- Isso garante que subprojetos em um monorepo usem seu próprio tsconfig
            return lspconfig.util.root_pattern("tsconfig.json")(filename)
              or lspconfig.util.root_pattern("package.json")(filename)
              or lspconfig.util.root_pattern("jsconfig.json")(filename)
          end,
          single_file_support = false,
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = true },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
            },
          },
          -- Use centralized keymaps from config/lsp-keymaps.lua
          keys = require("config.lsp-keymaps").vtsls_specific,
        },
      },
      setup = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
        vtsls = function(_, opts)
          -- Stop vtsls from attaching to Deno buffers
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "vtsls" then
                local is_deno = vim.fs.find(
                  { "deno.json", "deno.jsonc" },
                  { path = vim.api.nvim_buf_get_name(args.buf), upward = true }
                )[1] ~= nil
                if is_deno then
                  vim.lsp.stop_client(client.id)
                end
              end
            end,
          })

          if vim.lsp.config.denols and vim.lsp.config.vtsls then
            ---@param server string
            local resolve = function(server)
              local markers, root_dir = vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
              vim.lsp.config(server, {
                root_dir = function(bufnr, on_dir)
                  local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
                  if is_deno == (server == "denols") then
                    if root_dir then
                      return root_dir(bufnr, on_dir)
                    elseif type(markers) == "table" then
                      local root = vim.fs.root(bufnr, markers)
                      return root and on_dir(root)
                    end
                  end
                end,
              })
            end
            resolve("denols")
            resolve("vtsls")
          end

          LazyVim.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client:request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client:request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },


  -- File Icons
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },

}
