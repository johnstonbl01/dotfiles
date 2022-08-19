
local lsp = require('languages.lsp')
local M = {}

local home_dir = os.getenv("HOME")
local elixirls = home_dir .. "/.langservers/elixir-ls/language_server.sh"

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  flags = lsp.flags,
  cmd = { elixirls },
}

return M
