-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Native LSP (vim.lsp.enable), deferred to VeryLazy so blink.cmp (required for
-- capabilities) stays off the startup path. Safe: vim.lsp.enable() re-runs the
-- FileType autocmds for already-open buffers (doautoall), so the first file
-- still gets its servers.
if #vim.api.nvim_list_uis() == 0 then
  -- Headless: VeryLazy never fires (no UIEnter); load right after startup so
  -- scripted usage (tests, `nvim --headless +...`) still gets LSP.
  vim.schedule(function()
    require("config.lsp")
  end)
else
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      require("config.lsp")
    end,
  })
end
