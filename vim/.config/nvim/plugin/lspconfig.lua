capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { "utf-16" }

vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        features = 'all',
      },
      diagnostic = {
        styleLints = {
          enable = true,
        },
      },
    }
  },
})

vim.lsp.config('ruby_lsp', {
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

vim.lsp.config['herb_ls'] = {
  cmd = { 'herb-language-server', '--stdio' },
  filetypes = { 'html', 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
}

skCapabilities = capabilities
-- https://www.swift.org/documentation/articles/zero-to-swift-nvim.html#file-updating
skCapabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
vim.lsp.config('sourcekit', {
  capabilities = skCapabilities
})

vim.lsp.enable({
  'clangd',
  'eslint',
  -- 'gopls',
  'herb_ls',
  'ruby_lsp',
  'rubocop',
  'rust_analyzer',
  'sourcekit',
  'ts_ls',
})

require('lspconfig.ui.windows').default_options.border = 'rounded'
