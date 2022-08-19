local g = vim.g
local lsp = require('languages.lsp')
local M = {}

g.python3_host_prog = "/opt/homebrew/bin/python3"

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M
