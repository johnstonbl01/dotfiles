local api = vim.api
local M = {}

-- Credit https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
function M.on_attach(client, bufnr)
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

M.capabilities = capabilities

M.flags = { debounce_text_changes = 150 }

return M
