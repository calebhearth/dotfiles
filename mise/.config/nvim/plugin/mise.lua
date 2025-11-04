require('otter').setup {
  lsp = {
    diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
  }
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toml" },
  group = vim.api.nvim_create_augroup("EmbedToml", {}),
  callback = require("otter").activate,
})

require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
  local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
  local filename = vim.fn.fnamemodify(filepath, ":t")
  if string.match(filename, ".*mise.*%.toml$") ~= nil then
    return true
  end
  if string.match(filepath, ".*config/mise/config.*%.toml$") ~= nil then
    return true
  end
  return false
end, { force = true, all = false })
