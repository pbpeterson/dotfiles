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
  -- Dim the editor behind the fff pickers, like the snacks backdrop
  init = function()
    vim.api.nvim_set_hl(0, "FFFBackdrop", { bg = "#000000", default = true })

    local backdrop_win
    local group = vim.api.nvim_create_augroup("fff_backdrop", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "FFFOpen",
      callback = function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = "wipe"
        backdrop_win = vim.api.nvim_open_win(buf, false, {
          relative = "editor",
          row = 0,
          col = 0,
          width = vim.o.columns,
          height = vim.o.lines,
          style = "minimal",
          focusable = false,
          -- Above other floats like the snacks explorer (33), below fff windows (51+)
          zindex = 50,
        })
        vim.wo[backdrop_win].winhighlight = "Normal:FFFBackdrop"
        vim.wo[backdrop_win].winblend = 60
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "FFFClose",
      callback = function()
        if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
          vim.api.nvim_win_close(backdrop_win, true)
        end
        backdrop_win = nil
      end,
    })
  end,
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
