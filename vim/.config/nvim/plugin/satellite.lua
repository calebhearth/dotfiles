require('satellite').setup {
  gitsigns = {
    enable = false,
  },
  diagnostics = {
    error = { '-', '=', '≡', '≣' },
    warn = { '-', '=', '≡', '≣' },
    info = { '-', '=', '≡', '≣' },
    hint = { '∼', '≈', '≋' },
  },
  width = 10,
}
