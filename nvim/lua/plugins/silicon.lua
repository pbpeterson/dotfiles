-- Silicon - Code Screenshot Tool
-- Generate beautiful code screenshots with syntax highlighting
-- Usage: :Silicon (in visual mode to capture selection)
-- Automatically copies to clipboard

return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  opts = {
    to_clipboard = true,
    -- Kanagawa Wave theme to match the editor/WezTerm. Passed as a path so it
    -- works without building silicon's theme cache; bg pinned to sumiInk0.
    theme = vim.fn.expand("~/Library/Application Support/silicon/themes/kanagawa-wave.tmTheme"),
    background = "#16161D",
    line_offset = function(args)
      return args.line1
    end,
  },
}
