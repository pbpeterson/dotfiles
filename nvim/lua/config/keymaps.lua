-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Better indenting
-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Move lines up and down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste
-- Don't yank the replaced text when pasting in visual mode
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Quick save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Save file" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Decrease window width" })

-- Quickfix list navigation
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })

-- Location list navigation
map("n", "[l", "<cmd>lprev<CR>", { desc = "Previous location item" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next location item" })

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Center screen after certain movements
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Better terminal navigation
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window from terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window from terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window from terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
