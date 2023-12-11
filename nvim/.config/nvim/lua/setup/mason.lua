local mason = require("mason")
local mason_lsp = require("mason-lspconfig")

local servers = {
	"tsserver",
	"eslint",
	"lua_ls",
	"pyright",
	"ruff_lsp",
	"bashls",
	"cssls",
	"cssmodules_ls",
	"docker_compose_language_service",
	"dockerls",
	"gopls",
	"html",
	"jsonls",
	"marksman",
	"prismals",
	"rust_analyzer",
	"sqlls",
	"typos_lsp",
	"volar",
	"yamlls",
}

mason.setup()
mason_lsp.setup({ ensure_installed = servers })
