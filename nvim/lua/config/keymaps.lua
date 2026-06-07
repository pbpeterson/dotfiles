-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- LazyVim already provides: indenting, move lines, clear search, save, window nav,
-- resize, quickfix/location nav, buffer nav, terminal nav. Only custom additions below.

local map = vim.keymap.set

-- Better paste (don't yank the replaced text)
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Center screen after certain movements
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("n", "*", "*zzzv", { desc = "Search word forward and center" })
map("n", "#", "#zzzv", { desc = "Search word backward and center" })

-- Find files, most-recent-first: merges open buffers, MRU, and project files,
-- frecency-ranked even on an empty query (smart source, sort_empty = true).
map("n", "<leader><leader>", function()
  Snacks.picker.smart()
end, { desc = "Find Files (smart / recent)" })
