require('treesitter-context').setup{
  enable = true,
  max_lines=3,
  trim_scope = 'outer',
}

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
