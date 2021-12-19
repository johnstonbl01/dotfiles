local lsp = require('languages.lsp')
local M = {}

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
    filetypes = { "sh", "zsh" }
}

return M
