-- File-icon overrides (moved from the old plugins/lsp/{vtsls,denols}.lua)
return {
  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        ["deno.json"] = { glyph = "🦕", hl = "MiniIconsGreen" },
        ["deno.jsonc"] = { glyph = "🦕", hl = "MiniIconsGreen" },
        ["deno.lock"] = { glyph = "🦕", hl = "MiniIconsGreen" },
      },
    },
  },
}
