-- Marksman: Markdown LSP (goto definition for links, rename headings, etc.)

return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
