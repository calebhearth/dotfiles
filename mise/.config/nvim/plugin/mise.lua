require('otter').setup{
  lsp = {
    diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
  }
}

require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
  local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
  local filename = vim.fn.fnamemodify(filepath, ":t")
  return string.match(filename, ".*mise.*%.toml$")
end, { force = true, all = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toml" },
  group = vim.api.nvim_create_augroup("EmbedToml", {}),
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local query = vim.treesitter.query.get("toml", "mise")
    if query then
      vim.treesitter.query.set_query(bufnr, "mise", query)
    end
  end,
})
