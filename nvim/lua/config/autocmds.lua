-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- LazyVim already provides: highlight_yank, auto_create_dir, close_with_q,
-- checktime, resize_splits, last_loc, and all standard LSP keymaps.
-- Only custom additions below.

-- Copy current buffer path to clipboard (relative to project root/cwd)
vim.api.nvim_create_user_command("Copypath", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy current buffer path to clipboard (relative to cwd)" })
