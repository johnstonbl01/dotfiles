local null_ls = require('null-ls')

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.editorconfig_checker.with({
      command = "editorconfig-checker"
    }), null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.misspell,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.formatting.prettier
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      })
    end
  end
})
