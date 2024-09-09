vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
-- vim.opt.packpath = vim.opt.runtimepath vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vimrc")

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'css',
    'diff',
    'dockerfile',
    'dot',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'html',
    'javascript',
    'jq',
    'json',
    'lua',
    'python',
    'ruby',
    'sql',
    'ssh_config',
    'swift',
    'tmux',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  }
}

require('treesitter-context').setup{
  enable = true,
  max_lines=3,
  trim_scope = 'outer',
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, filetype, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, filetype, opts, ...)
end
require('lspconfig.ui.windows').default_options.border = 'rounded'

require('lspconfig').sourcekit.setup{}

require'lspconfig'.rubocop.setup{}
require'lspconfig'.clangd.setup{}

require'lspconfig'.ruby_lsp.setup {
  init_options = {
    enabledFeatures = {
      semanticHighlighting = false,
      hover = true,
    }
  },
  --semanticHighlighting = false,
  -----@param client lsp.Client
  --on_init = function(client)
  --  print(vim.inspect(client.server_capabilities))
  --  client.server_capabilities.semanticTokensProvider = nil  -- turn off semantic tokens
  --end,
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method('textDocument/hover') then
      -- vim.bo[args.buf].keywordprg = 'v:lua.vim.lsp.buf.hover'
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = 'vim.lsp.buf.hover()' })
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
