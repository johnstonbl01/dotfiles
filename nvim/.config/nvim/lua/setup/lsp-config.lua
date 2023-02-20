local g = vim.g
local lsp_config = require('lspconfig')

-- disable perl provider
g.loaded_perl_provider = 0

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>gr', require('telescope.builtin').lsp_references,
    '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols,
    '[D]ocument [S]ymbols')
  nmap('<leader>ws',
    require('telescope.builtin').lsp_dynamic_workspace_symbols,
    '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

require('mason').setup()

local servers = {
  'clangd', 'rust_analyzer', 'pyright', 'bashls', 'cssls', 'dockerls',
  'elixirls', 'emmet_ls', 'erlangls', 'gopls', 'graphql', 'html', 'jsonls',
  'tsserver', 'kotlin_language_server', 'lua_ls', 'marksman', 'prismals',
  'ruby_ls', 'sqlls', 'tailwindcss', 'terraformls', 'stylelint_lsp', 'svelte',
  'taplo', 'vuels', 'yamlls', 'phpactor'
}

require('mason-lspconfig').setup { ensure_installed = servers }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

require('fidget').setup()

g.python3_host_prog = "/opt/homebrew/bin/python3"
g.ruby_host_prog = "/usr/local/opt/ruby/bin/ruby"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lsp_config.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = runtime_path },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false }
    }
  }
}

lsp_config.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sh", "zsh" }
}

lsp_config.sourcekit.setup { on_attach = on_attach, capabilities = capabilities }

local function filter(arr, fn)
  if type(arr) ~= "table" then return arr end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then table.insert(filtered, v) end
  end

  return filtered
end

local function filterDefFiles(value)
  return string.match(value.targetUri, 'react/index.d.ts') == nil
end

lsp_config.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = { preferences = { includeCompletionsForModuleExports = false } },
  handlers = {
    ['textDocument/definition'] = function(err, result, ...)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterDefFiles)
        return vim.lsp.handlers['textDocument/definition'](err,
          filtered_result,
          ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, ...)
    end
  }
}
