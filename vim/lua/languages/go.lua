local lsp = require('languages.lsp')
local M = {}

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  flags = lsp.flags,
  cmd = { 'gopls', 'serve' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      }
    }
  }
}

return M