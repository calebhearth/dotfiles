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

require'lspconfig'.rubocop.setup{}

require'lspconfig'.ruby_lsp.setup {
  semanticHighlighting = false,
  ---@param client lsp.Client
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil  -- turn off semantic tokens
  end,
}

local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "swift" },
  callback = function()
    local root_dir = vim.fs.dirname(vim.fs.find({
      "Package.swift",
      ".git",
    }, { upward = true })[1])
    local client = vim.lsp.start({
      name = "sourcekit-lsp",
      cmd = { "sourcekit-lsp" },
      root_dir = root_dir,
    })
    vim.lsp.buf_attach_client(0, client)
  end,
  group = swift_lsp,
})
