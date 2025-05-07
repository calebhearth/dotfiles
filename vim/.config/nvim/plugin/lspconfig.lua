capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { "utf-16" }

vim.lsp.config('ruby_lsp', {
  capabilities = capabilities,
  init_options = {
    rubyLsp = {
      featuresConfiguration = {
        inlayHint = {
          enableAll = true,
        },
      },
      rubyVersionManager = {
        identifier = 'mise',
      },
    },
  },
})

vim.lsp.enable({
  'clangd',
  'gopls',
  'ruby_lsp',
  'rubocop',
  'rust_analyzer',
  'sourcekit',
  'ts_ls',
})

require('lspconfig.ui.windows').default_options.border = 'rounded'
