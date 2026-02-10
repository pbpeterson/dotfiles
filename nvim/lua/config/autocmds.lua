-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
-- Brief highlight when you copy text
augroup("highlight_yank", { clear = true })
autocmd("TextYankPost", {
  group = "highlight_yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight text on yank",
})

-- Auto-create directories when saving a file
-- Useful when creating new files in non-existent directories
augroup("auto_create_dir", { clear = true })
autocmd("BufWritePre", {
  group = "auto_create_dir",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create parent directories when saving a file",
})

-- Close certain filetypes with q
augroup("close_with_q", { clear = true })
autocmd("FileType", {
  group = "close_with_q",
  pattern = {
    "help",
    "lspinfo",
    "checkhealth",
    "qf",
    "query",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close with q" })
  end,
  desc = "Close certain filetypes with q",
})

-- Check if we need to reload the file when it changed
augroup("checktime", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check if file needs reloading",
})

-- Resize splits when window is resized
augroup("resize_splits", { clear = true })
autocmd("VimResized", {
  group = "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Resize splits when window is resized",
})

-- Keep relative line numbers always enabled
-- (Removed the toggle between relative/absolute on insert mode)

-- Go to last location when opening a buffer
augroup("last_loc", { clear = true })
autocmd("BufReadPost", {
  group = "last_loc",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening a buffer",
})

-- Remove trailing whitespace on save
augroup("trim_whitespace", { clear = true })
autocmd("BufWritePre", {
  group = "trim_whitespace",
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Global LSP keymaps (baseline for all servers, per-server keymaps can override)
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
