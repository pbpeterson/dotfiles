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
    line_offset = function(args)
      return args.line1
    end,
  },
}
