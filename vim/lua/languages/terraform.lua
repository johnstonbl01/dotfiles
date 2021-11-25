local lsp = require('languages.lsp')
local M = {}

M.lsp = {
    cmd = { "terraform-ls", "serve" },
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M