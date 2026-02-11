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

-- Deno project marker files
M.deno_markers = { "deno.json", "deno.jsonc" }

-- Check if a path is within a Deno project
---@param path? string file path or directory to check (defaults to cwd)
---@return boolean
function M.is_deno_project(path)
  return vim.fs.find(M.deno_markers, { path = path or vim.fn.getcwd(), upward = true })[1] ~= nil
end

return M
