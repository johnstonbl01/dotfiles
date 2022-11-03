local lsp = require('languages.lsp')
local M = {}

local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterDefFiles(value)
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  flags = lsp.flags,
  handlers = {
    ['textDocument/definition'] = function(err, result, ...)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterDefFiles)
        return vim.lsp.handlers['textDocument/definition'](err, filtered_result, ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, ...)
    end
  }
}

return M
