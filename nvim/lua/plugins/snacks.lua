-- Snacks plugin configuration
-- Smooth scrolling is disabled for better performance
local constants = require("config.constants")

return {
  -- Disable noice.nvim (replaced by snacks notifier/input)
  { "folke/noice.nvim", enabled = false },
  { "MunifTanjim/nui.nvim", enabled = false },

  -- Disable bufferline (use <leader>, for buffer picker instead)
  { "akinsho/bufferline.nvim", enabled = false },

  -- Disable unused plugins
  { "nvim-lua/plenary.nvim", enabled = false },
  -- tokyonight is the LazyVim default theme; we use kanagawa, so drop it entirely.
  -- Must set LazyVim's colorscheme first (below) or startup errors loading tokyonight.
  { "folke/tokyonight.nvim", enabled = false },

  -- Tell LazyVim the active colorscheme so it stops requiring tokyonight at startup
  { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },

  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      indent = {
        enabled = true,
        char = "│",
        scope = { enabled = true },
      },
      notifier = { enabled = true },
      input = { enabled = true },
      styles = {
        notification = { border = "rounded" },
        notification_history = { border = "rounded" },
        input = { border = "rounded" },
      },
      picker = {
        sources = {
          explorer = {
            ignored = true,
            exclude = constants.exclude_patterns,
          },
          files = {
            ignored = true,
            exclude = constants.exclude_patterns,
          },
          -- <leader><leader> uses the smart source (buffers + MRU + files).
          -- It's a separate source, so the files excludes above don't apply;
          -- repeat them here or node_modules/dist/etc. leak into results.
          -- filter.cwd scopes the MRU/recent list to the project, otherwise
          -- vim.v.oldfiles floods results with files from every other repo.
          smart = {
            ignored = true,
            exclude = constants.exclude_patterns,
            filter = { cwd = true },
          },
        },
      },
      dashboard = {
        preset = {
          header = [[

      ⣀⣤⣶⣶⣦⣄⡀                            神    奈    川
   ⢀⣴⠟⠋⠁  ⠈⠙⠻⣦⡀     ╭───────────────────────────╮
  ⣰⡟⠁    ⢀⣀⣀⡀   ⠹⣧    │   K A N A G A W A   波    │
 ⢠⡟    ⣰⠟⠋⠉⠙⠻⣦⡀  ⢻⡄   ╰───────────────────────────╯
 ⣾⠁   ⣼⠏      ⠹⣧  ⢸⣷       浪 の 如 く 流 れ よ
 ⢿⡄   ⠹⣧⡀    ⢀⣴⠏  ⣼⡿
 ⠈⢿⣦⡀   ⠉⠛⠷⠶⠾⠛⠁ ⢀⣴⡿⠁           the great wave
   ⠙⠻⢷⣦⣤⣄⣀⣀⣠⣤⣶⡾⠟⠋
      ⠈⠉⠛⠛⠛⠛⠉⠁
]],
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
