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

-- Open media files with IINA instead of displaying binary text
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.mp3", "*.mp4", "*.mkv", "*.avi", "*.mov", "*.flac", "*.wav", "*.m4a" },
  callback = function(ev)
    local path = vim.fn.expand("<afile>:p")
    vim.fn.jobstart({ "open", "-a", "IINA", "-g", path }, { detach = true })
    vim.defer_fn(function()
      vim.api.nvim_buf_delete(ev.buf, { force = true })
    end, 0)
  end,
})
