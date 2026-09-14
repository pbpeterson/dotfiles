-- Fast fuzzy file finder and live grep
return {
  "dmtrKovalenko/fff",
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  -- Match the look of the snacks picker it replaces
  opts = {
    prompt = " ",
    layout = {
      prompt_position = "top",
      border = "rounded",
      show_path_first = true,
    },
    hl = {
      border = "FFFBorder",
      title = "FloatTitle",
      prompt = "Special",
      matched = "Special",
      grep_match = "Special",
      directory_path = "NonText",
      cursor = "CursorLine",
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  keys = {
    {
      "ff",
      function()
        require("fff").find_files()
      end,
      desc = "FFFind files",
    },
    {
      "fg",
      function()
        require("fff").live_grep()
      end,
      desc = "LiFFFe grep",
    },
    {
      "fz",
      function()
        require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "Live fffuzy grep",
    },
    {
      "fw",
      function()
        require("fff").live_grep_under_cursor()
      end,
      mode = { "n", "x" },
      desc = "Search current word / selection",
    },
    -- Override LazyVim picker keymaps (snacks + ripgrep) with fff
    {
      "<leader><space>",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files (fff)",
    },
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files (fff)",
    },
    {
      "<leader>fF",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files (fff)",
    },
    {
      "<leader>fg",
      function()
        require("fff").find_files()
      end,
      desc = "Find Files (fff)",
    },
    {
      "<leader>/",
      function()
        require("fff").live_grep()
      end,
      desc = "Grep (fff)",
    },
    {
      "<leader>sg",
      function()
        require("fff").live_grep()
      end,
      desc = "Grep (fff)",
    },
    {
      "<leader>sG",
      function()
        require("fff").live_grep()
      end,
      desc = "Grep (fff)",
    },
    {
      "<leader>sw",
      function()
        require("fff").live_grep_under_cursor()
      end,
      mode = { "n", "x" },
      desc = "Grep Word / Selection (fff)",
    },
    {
      "<leader>sW",
      function()
        require("fff").live_grep_under_cursor()
      end,
      mode = { "n", "x" },
      desc = "Grep Word / Selection (fff)",
    },
  },
}
