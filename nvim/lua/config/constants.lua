-- Shared constants used across the Neovim configuration

local M = {}

-- Common patterns to exclude from file pickers, explorers, etc.
M.exclude_patterns = {
  "node_modules",
  ".git",
  "dist",
  "build",
  ".next",
  "__pycache__",
  "*.pyc",
  ".DS_Store",
}

return M
