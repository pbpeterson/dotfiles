-- HTML/JSX Auto Tag
-- Automatically closes and renames HTML/JSX tags
return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
