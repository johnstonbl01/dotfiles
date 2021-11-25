local util = require('lspconfig.util')
local M = {}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
}

local function find_root_dir(fname)
    return util.root_pattern("tsconfig.json")(fname) or
    util.root_pattern(".eslintrc.js", ".eslintrc.json", ".git")(fname);
end

M.lsp = {
  init_options = { documentFormatting = true, codeAction = true },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  root_dir = find_root_dir,
  settings = {
    rootMarkers = {".eslintrc.js", ".eslintrc.json", ".git/"},
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      typescript = {eslint},
      typescriptreact = {eslint}
    }
  }
}

return M