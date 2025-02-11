require('lspconfig').clangd.setup{}

require('lspconfig').ruby_lsp.setup {
  -- init_options = {
  --   enabledFeatures = {
  --     semanticHighlighting = false,
  --     hover = true,
  --   }
  -- },
  --semanticHighlighting = false,
  -----@param client lsp.Client
  --on_init = function(client)
  --  print(vim.inspect(client.server_capabilities))
  --  client.server_capabilities.semanticTokensProvider = nil  -- turn off semantic tokens
  --end,
}

require('lspconfig').rubocop.setup{}

require('lspconfig').sourcekit.setup{
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}

require('lspconfig').ts_ls.setup{}

require('lspconfig.ui.windows').default_options.border = 'rounded'
