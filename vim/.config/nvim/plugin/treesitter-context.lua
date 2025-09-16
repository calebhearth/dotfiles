require('treesitter-context').setup {
  enable = true,
  max_lines = 3,
  trim_scope = 'outer',
  multiwindow = true,
  on_attach = function(bufnr)
    return vim.api.nvim_get_option_value('filetype', { buf = bufnr, scope = "local" }) ~= "markdown"
  end
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
