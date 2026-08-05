-- VTsls (Visual Studio TypeScript Language Server)
-- Native LSP config (vim.lsp.enable). Skips Deno projects; prioritizes the
-- closest tsconfig.json so monorepo subprojects get their own server root.

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" or require("config.constants").is_deno_project(fname) then
      return
    end
    local root = vim.fs.root(bufnr, { "tsconfig.json" })
      or vim.fs.root(bufnr, { "package.json", "jsconfig.json" })
      or vim.fs.dirname(fname) -- single-file fallback
    on_dir(root)
  end,
  on_attach = function(client, _)
    -- Interactive destination picker for the "Move to file" refactoring
    client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
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
  end,
  settings = (function()
    local ts = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    }
    local js = vim.tbl_deep_extend("force", {}, ts, {
      inlayHints = {
        parameterNames = { enabled = "all" },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = false },
        functionLikeReturnTypes = { enabled = false },
        enumMemberValues = { enabled = false },
      },
    })
    return {
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
      typescript = ts,
      javascript = js,
    }
  end)(),
}
