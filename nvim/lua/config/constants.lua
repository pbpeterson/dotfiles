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

-- oxlint/oxfmt project marker files
M.oxlint_markers = { ".oxlintrc.json" }
M.oxfmt_markers = { ".oxfmtrc.json" }

-- Check if a path is within a Deno project
---@param path? string file path or directory to check (defaults to cwd)
---@return boolean
function M.is_deno_project(path)
  return vim.fs.find(M.deno_markers, { path = path or vim.fn.getcwd(), upward = true })[1] ~= nil
end

-- Check if a path is within an oxlint project
---@param path? string file path or directory to check (defaults to cwd)
---@return boolean
function M.is_oxlint_project(path)
  return vim.fs.find(M.oxlint_markers, { path = path or vim.fn.getcwd(), upward = true })[1] ~= nil
end

-- Check if a path is within an oxfmt project
---@param path? string file path or directory to check (defaults to cwd)
---@return boolean
function M.is_oxfmt_project(path)
  return vim.fs.find(M.oxfmt_markers, { path = path or vim.fn.getcwd(), upward = true })[1] ~= nil
end

return M
