require('nvim-treesitter.configs').setup {
  auto_install = true,
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
    'rust',
    'sql',
    'ssh_config',
    'swift',
    'tmux',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  -- },
  -- highlight = {
  --   additional_vim_regex_highlighting = true,
  --   enable = true,
  }
}
