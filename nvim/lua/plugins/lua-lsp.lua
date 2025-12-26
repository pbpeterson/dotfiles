-- Lua LSP configuration for Neovim config development
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
              hint = {
                enable = true,
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },

  -- Ensure lua_ls is installed via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "lua-language-server")
    end,
  },
}
