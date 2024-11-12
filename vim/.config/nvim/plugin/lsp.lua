local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, filetype, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, filetype, opts, ...)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method('textDocument/hover') then
      -- vim.bo[args.buf].keywordprg = 'v:lua.vim.lsp.buf.hover'
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {
        buffer = args.buf,
        desc = 'vim.lsp.buf.hover()'
      })
    end
    if client.supports_method('textDocument/definition') then
      vim.bo[args.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end
    if client.supports_method('textDocument/completion') then
      vim.bo[args.buf].omnifunc = ':lua vim.lsp.omnifunc'
    end
    if client.supports_method('textDocument/rangeFormatting') then
      vim.bo[args.buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end
  end,
})
