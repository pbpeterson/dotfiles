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

-- Render the current SVG to PNG with resvg, then open it in the default viewer.
-- Needs `resvg` on PATH.
vim.api.nvim_create_user_command("SvgPreview", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("SvgPreview: buffer has no file on disk", vim.log.levels.ERROR)
    return
  end

  -- One file per buffer name, so two open SVGs do not overwrite each other.
  local output = vim.fn.stdpath("cache") .. "/svg-preview/" .. vim.fn.expand("%:t:r") .. ".png"
  vim.fn.mkdir(vim.fn.fnamemodify(output, ":h"), "p")

  local result = vim.fn.system({ "resvg", file, output })
  if vim.v.shell_error ~= 0 then
    vim.notify("SvgPreview: resvg failed\n" .. result, vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ "open", output }, { detach = true })
end, { desc = "Render the current SVG to PNG and open it" })

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
