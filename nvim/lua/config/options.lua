-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Text wrapping settings
-- These override LazyVim defaults to enable better text wrapping
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Break at word boundaries (not mid-word)
vim.opt.breakindent = true -- Maintain indentation on wrapped lines

-- UI settings
vim.opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
vim.opt.showtabline = 0 -- Hide the tabline (buffer tabs)

-- Performance optimizations
vim.opt.updatetime = 250 -- Faster completion (default is 4000ms)
vim.opt.timeoutlen = 300 -- Faster key sequence completion
vim.opt.redrawtime = 800 -- Time in milliseconds for redrawing the display
vim.opt.ttimeoutlen = 10 -- Time in milliseconds to wait for a key code sequence

-- Swap and backup settings for better performance
vim.opt.swapfile = false -- Disable swap file (use backup instead)
vim.opt.backup = false -- Disable backup file
vim.opt.writebackup = false -- Disable backup before overwriting file
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undolevels = 2000 -- Maximum number of changes that can be undone

-- Search settings
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Override ignorecase if search contains capitals

-- Performance: limit syntax highlighting on long lines
vim.opt.synmaxcol = 300 -- Only highlight first 300 columns

-- Global rounded borders for all floating windows (nvim 0.12 native)
vim.o.winborder = "rounded"

-- Nicer diagnostics: rounded float, custom sign icons, inline virtual text
vim.diagnostic.config({
  float = { border = "rounded", source = "if_many" },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})
