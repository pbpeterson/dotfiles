-- HTML/JSX Auto Tag
-- Automatically closes and renames HTML/JSX tags
return {
  {
    "windwp/nvim-ts-autotag",
    -- ft only (no event): event would OR with ft and load on every file open
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  },
}
