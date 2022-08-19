local g = vim.g
local lsp = require('lspconfig')

-- disable perl provider
g.loaded_perl_provider = 0

lsp.bashls.setup(require('languages.bash').lsp)
lsp.cssls.setup(require('languages.css').lsp)
lsp.efm.setup(require('languages.efm').lsp)
lsp.elixirls.setup(require('languages.elixir').lsp)
lsp.gopls.setup(require('languages.go').lsp)
lsp.html.setup(require('languages.html').lsp)
lsp.tsserver.setup(require('languages.javascript').lsp)
lsp.jsonls.setup(require('languages.json').lsp)
lsp.sumneko_lua.setup(require('languages.lua').lsp)
lsp.ltex.setup(require('languages.markdown').lsp)
lsp.pyright.setup(require('languages.python').lsp)
lsp.solargraph.setup(require('languages.ruby').lsp)
lsp.rust_analyzer.setup(require('languages.rust').lsp)
lsp.svelte.setup(require('languages.svelte').lsp)
lsp.tailwindcss.setup(require('languages.tailwind').lsp)
lsp.terraformls.setup(require('languages.terraform').lsp)
lsp.vimls.setup(require('languages.vim').lsp)
lsp.vuels.setup(require('languages.vue').lsp)
lsp.yamlls.setup(require('languages.yaml'))
