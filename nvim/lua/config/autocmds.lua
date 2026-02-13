-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- LazyVim already provides: highlight_yank, auto_create_dir, close_with_q,
-- checktime, resize_splits, last_loc. Only custom additions below.

-- Global LSP keymaps (baseline for all servers, per-server keymaps can override)
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("lsp_keymaps", { clear = true })
autocmd("LspAttach", {
  group = "lsp_keymaps",
  callback = function(event)
    local opts = function(desc)
      return { buffer = event.buf, silent = true, desc = desc }
    end
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts("Signature Help"))
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename"))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next Diagnostic"))
  end,
  desc = "Set global LSP keymaps on attach",
})

-- Copy current buffer path to clipboard (relative to project root/cwd)
vim.api.nvim_create_user_command("Copypath", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy current buffer path to clipboard (relative to cwd)" })
