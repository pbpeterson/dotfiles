-- TailwindCSS Language Server
-- Roots on a tailwind config file; for Tailwind v4 (CSS-first, no config file)
-- falls back to the nearest package.json that declares a tailwindcss dependency,
-- so the server doesn't start in unrelated projects.

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "sass",
    "less",
    "postcss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
    "templ",
    "mdx",
    -- Phoenix/Elixir templates
    "heex",
    "elixir",
    "eelixir",
  },
  root_dir = function(bufnr, on_dir)
    local config_root = vim.fs.root(bufnr, {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
    })
    if config_root then
      return on_dir(config_root)
    end
    local pkg_root = vim.fs.root(bufnr, { "package.json" })
    if pkg_root then
      local ok, pkg = pcall(vim.fn.readfile, pkg_root .. "/package.json")
      if ok and table.concat(pkg, "\n"):find('"tailwindcss"', 1, true) then
        return on_dir(pkg_root)
      end
    end
  end,
  settings = {
    tailwindCSS = {
      validate = true,
      includeLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
  },
}
