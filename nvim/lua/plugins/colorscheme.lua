-- Catppuccin color scheme with plugin integrations
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    term_colors = true,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      keywords = { "bold" },
    },
    integrations = {
      cmp = true,
      flash = true,
      fzf = true,
      gitsigns = true,
      indent_blankline = { enabled = true, scope_color = "lavender" },
      mason = true,
      mini = { enabled = true },
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      neotree = true,
      noice = true,
      notify = true,
      snacks = true,
      telescope = { enabled = true },
      treesitter = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
