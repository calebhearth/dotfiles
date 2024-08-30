require'nvim-treesitter.configs'.setup {
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

require'treesitter-context'.setup{
  enable = true,
  max_lines=3,
  trim_scope = 'outer',
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

require'lspconfig'.sourcekit.setup{}

require'lspconfig'.rubocop.setup{}
require'lspconfig'.clangd.setup{}

require'lspconfig'.ruby_lsp.setup {
  semanticHighlighting = false,
  ---@param client lsp.Client
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil  -- turn off semantic tokens
  end,
}
