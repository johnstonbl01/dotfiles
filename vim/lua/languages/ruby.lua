local g = vim.g
local lsp = require('languages.lsp')
local M = {}

g.ruby_host_prog= "/opt/homebrew/opt/ruby/bin/ruby"

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M
