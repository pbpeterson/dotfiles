-- Native LSP bootstrap (nvim 0.12) — replaces nvim-lspconfig + mason.
-- Server definitions live in <config>/lsp/*.lua; this file wires capabilities,
-- recreates the LazyVim LSP keymaps on LspAttach, and enables the servers.
-- Loaded on VeryLazy (see init.lua); vim.lsp.enable() re-attaches to buffers
-- opened before it runs, so the first file still gets its servers.

-- blink.cmp completion capabilities must be registered before any server
-- starts; requiring it here forces the (otherwise InsertEnter-lazy) plugin to
-- load now — off the startup path, since we're already past UIEnter.
local capabilities = vim.tbl_deep_extend(
  "force",
  require("blink.cmp").get_lsp_capabilities(),
  -- Let servers send workspace/willRenameFiles etc. (Snacks.rename integration)
  { workspace = { fileOperations = { didRename = true, willRename = true } } }
)

vim.lsp.config("*", { capabilities = capabilities })

-- Keymap applier for LazyKeys-style specs ({lhs, rhs, desc=, mode=, has=,
-- nowait=, enabled=}), shared with the server-specific tables in
-- config/lsp-keymaps.lua. `has` = LSP method (bare names get textDocument/
-- prefixed), checked against the attaching client.
local function apply_keys(client, bufnr, keys)
  for _, key in ipairs(keys) do
    local ok = true
    if key.has then
      ok = false
      local methods = type(key.has) == "string" and { key.has } or key.has
      for _, method in ipairs(methods) do
        method = method:find("/") and method or ("textDocument/" .. method)
        if client:supports_method(method, bufnr) then
          ok = true
          break
        end
      end
    end
    if ok and key.enabled ~= nil then
      ok = type(key.enabled) == "function" and key.enabled(bufnr) or key.enabled == true
    end
    if ok then
      vim.keymap.set(key.mode or "n", key[1], key[2], {
        buffer = bufnr,
        desc = key.desc,
        nowait = key.nowait,
        silent = true,
      })
    end
  end
end

-- LazyVim-parity buffer-local keymaps (formerly set by the nvim-lspconfig spec)
-- stylua: ignore
local default_keys = {
  { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
  { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
  { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
  { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
  { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
  { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", has = "codeLens" },
  { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  { "<leader>cA", function() LazyVim.lsp.action.source() end, desc = "Source Action", has = "codeAction" },
  { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", has = "documentHighlight", enabled = function() return Snacks.words.is_enabled() end },
  { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", has = "documentHighlight", enabled = function() return Snacks.words.is_enabled() end },
  { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, desc = "Next Reference", has = "documentHighlight", enabled = function() return Snacks.words.is_enabled() end },
  { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", has = "documentHighlight", enabled = function() return Snacks.words.is_enabled() end },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    apply_keys(client, ev.buf, default_keys)

    -- Server-specific keymaps (set after defaults so they win)
    local lsp_keymaps = require("config.lsp-keymaps")
    if client.name == "vtsls" then
      apply_keys(client, ev.buf, lsp_keymaps.vtsls_specific)
    elseif client.name == "denols" then
      apply_keys(client, ev.buf, lsp_keymaps.typescript_common)
      apply_keys(client, ev.buf, lsp_keymaps.deno_specific)
    end

    -- Inlay hints on by default (toggle with <leader>uh via Snacks)
    if client:supports_method("textDocument/inlayHint", ev.buf) then
      local buf = ev.buf
      if
        vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buftype == ""
        and vim.bo[buf].filetype ~= "vue"
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      end
    end
  end,
})

vim.lsp.enable({ "vtsls", "denols", "tailwindcss", "lua_ls", "jsonls", "marksman" })
