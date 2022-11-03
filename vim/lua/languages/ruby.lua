local g = vim.g
local lsp = require('languages.lsp')
local M = {}

g.ruby_host_prog= "/usr/local/opt/ruby/bin/ruby"

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M
