local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, filetype, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, filetype, opts, ...)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/hover') then
      -- vim.bo[args.buf].keywordprg = 'v:lua.vim.lsp.buf.hover'
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {
        buffer = args.buf,
        desc = 'vim.lsp.buf.hover()'
      })
    end
    if client:supports_method('textDocument/definition') then
      vim.bo[args.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end
    if client:supports_method('textDocument/completion') then
      vim.bo[args.buf].omnifunc = ':lua vim.lsp.omnifunc'
    end
    if client:supports_method('textDocument/rangeFormatting') then
      vim.bo[args.buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end
    if client:supports_method('textDocument/diagnostics') then
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
        buffer = args.buf,
        desc = 'vim.diagnostic.goto_prev()'
      })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
        buffer = args.buf,
        desc = 'vim.diagnostic.goto_next()'
      })
    end
    if not client:supports_method('textDocument/willSaveWaitUntil')
       and client:supports_method('textDocument/formatting') then
       vim.api.nvim_create_autocmd("BufWritePre", {
         group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
         buffer = args.buf,
         callback = function()
          vim.lsp.buf.format({
            bufnr = args.buf,
            id = client.id,
            timeout_ms = 500,
          })
        end,
      })
    end
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end
})

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({ event = 'BufWritePre', buffer = args.buf })
    end
  end
})

-- LSP inlays will look like Comments but also be underdotted.
vim.api.nvim_set_hl(0, 'LspInlayHint', vim.tbl_extend(
  'force',
  vim.api.nvim_get_hl(0, { name='Comment' }),
  { underdotted = true })
)

-- function lsp_progress()
--   local messages = vim.lsp.status()
--   if #messages == 0 then
--     return ''
--   end
--   local status = {}
--   for _, msg in pairs(messages) do
--     table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ""))
--   end
--   local spinners = {'⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'}
--   local ms = vim.loop.hrtime() / 1000000
--   local frame = math.floor(ms / 120) % #spinners
--   return table.concat(status, ' | ') .. ' ' .. spinners[frame + 1]
-- end

-- return {
--   {
--     config = function(_, opts)
--       local client_capabilities = vim.lsp.protocol.make_client_capabilities()
--       local function setup(server)
--         local server_opts = vim.deep_extend('force', {
--           capabilities = vim.deepcopy(client_capabilities),
--         }, opts.servers[server] or {})
--         -- FIXME: workaround for https://github.com/neovim/neovim/issues/28058
--         for _, v in pairs(server_opts) do
--           if type(v) == "table" and v.workspace then
--             v.workspace.didChangeWatchedFiles = {
--               dynamicRegistration = false,
--               relativePatternSupport = false,
--             }
--           end
--         end

--         require("lspconfig")[server].setup(server_opts)
--       end

--       for server, _ in pairs(opts.servers) do
--         setup(server)
--       end
--     end
--   }
-- }
