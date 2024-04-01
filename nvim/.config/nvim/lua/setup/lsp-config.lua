local g = vim.g
local lsp_config = require("lspconfig")
local util = require("lspconfig.util")
local fidget = require("fidget")

-- disable perl provider
g.loaded_perl_provider = 0

fidget.setup()

local function get_typescript_server_path(root_dir)
	local global_ts = "/Users/blake/Library/pnpm/global/5/node_modules/typescript/lib"

	local found_ts = ""

	local function check_dir(path)
		found_ts = util.path.join(path, "node_modules", "typescript", "lib")
		if util.path.exists(found_ts) then
			return path
		end
	end
	if util.search_ancestors(root_dir, check_dir) then
		return found_ts
	else
		return global_ts
	end
end

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp_config.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		preferences = {
			disableSuggestions = true,
		},
	},
})

lsp_config.eslint.setup({
	packageManager = "pnpm",
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.lua_ls.setup({
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
})

lsp_config.pyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.ruff_lsp.setup({
	on_attach = function(client)
		-- Disable hover in favor of pyright
		client.server_capabilities.hoverProvider = false
	end,
	capabilities = capabilities,
})

lsp_config.bashls.setup({
	filetypes = { "sh", "zsh" },
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.cssmodules_ls.setup({
	on_attach = function(client)
		-- avoid conflict with typescript
		client.server_capabilities.definitionProvider = false
		on_attach(client)
	end,
	capabilities = capabilities,
	init_options = {
		camelCase = "dashes",
	},
})

lsp_config.docker_compose_language_service.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.marksman.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.prismals.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.sqlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.yamlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.typos_lsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.volar.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "vue" },
	init_options = {
		typescript = {
			tsdk = "/Users/blake/Library/pnpm/global/5/node_modules/typescript/lib",
		},
	},
	on_new_config = function(new_config, new_root_dir)
		new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
	end,
})

lsp_config.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
		},
	},
})

-- below lsps are usijng snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_config.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lsp_config.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- local function filter(arr, fn)
-- 	if type(arr) ~= "table" then
-- 		return arr
-- 	end
--
-- 	local filtered = {}
-- 	for k, v in pairs(arr) do
-- 		if fn(v, k, arr) then
-- 			table.insert(filtered, v)
-- 		end
-- 	end
--
-- 	return filtered
-- end
--
-- local function filterDefFiles(value)
-- 	return string.match(value.targetUri, "react/index.d.ts") == nil
-- end

-- lsp_config.tsserver.setup {
-- on_attach = on_attach,
-- capabilities = capabilities,
-- init_options = {preferences = {includeCompletionsForModuleExports = false}},
-- handlers = {
-- ['textDocument/definition'] = function(err, result, ...)
-- if vim.tbl_islist(result) and #result > 1 then
-- local filtered_result = filter(result, filterDefFiles)
-- return vim.lsp.handlers['textDocument/definition'](err,
-- filtered_result,
-- ...)
-- end
--
-- vim.lsp.handlers['textDocument/definition'](err, result, ...)
-- end
-- }
-- }
