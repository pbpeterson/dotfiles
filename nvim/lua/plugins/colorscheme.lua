-- Kanagawa (wave) color scheme with cohesive UI overrides
-- After changing colors/overrides below, run :KanagawaCompile (compile=true caches highlights)
return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  lazy = false,
  priority = 1000,
  opts = {
    compile = true, -- compile highlights to bytecode (run :KanagawaCompile after changes)
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { bold = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false, -- set true for a fully transparent background
    dimInactive = true, -- dim non-current windows/splits
    terminalColors = true, -- apply theme to :terminal
    theme = "wave",
    background = { dark = "wave", light = "lotus" },
    -- Cleaner UI: no distracting gutter background
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    -- Per-highlight tweaks: unified floats, borderless pickers, italic conditionals
    overrides = function(colors)
      local theme = colors.theme
      return {
        -- Italic conditionals/loops (parity with old catppuccin styles.conditionals)
        ["@keyword.conditional"] = { italic = true },
        ["@keyword.repeat"] = { italic = true },

        -- Floating windows: single elevated surface so border blends in
        NormalFloat = { bg = theme.ui.bg_m3 },
        FloatBorder = { bg = theme.ui.bg_m3, fg = theme.ui.bg_m3 },
        FloatTitle = { bg = theme.ui.bg_m3, fg = theme.ui.special, bold = true },

        -- Popup menu (blink / completion) matches floats
        Pmenu = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },

        -- Borderless Telescope/snacks-picker look (prompt/results/preview as panes)
        TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa")
  end,
}
