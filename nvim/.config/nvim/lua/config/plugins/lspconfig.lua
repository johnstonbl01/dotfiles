local required_lsps =
	{ "lua_ls", "ts_ls", "eslint", "typos_lsp", "cssls", "cssmodules_ls", "dockerls", "html", "jsonls", "yamlls" }
local formatters = { "prettier", "stylua", "shfmt" }

local lsp_config = {
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- Ignore Lua_LS's noisy `missing-fields` warnings
				diagnostics = { disable = { "missing-fields" } },
			},
		},
	},
	ts_ls = {
		init_options = {
			hostInfo = "neovim",
			maxTsServerMemory = 8192,
		},
		capabilities = {
			server_capabilities = {
				documentFormattingProvider = false,
			},
		},
	},
}

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"mhanberg/output-panel.nvim",
			-- Enable to debug LSP logs
			enabled = true,
			event = "VeryLazy",
			config = function()
				require("output_panel").setup({})
			end,
		},
	},

	config = function()
		require("mason").setup({})
		require("mason-tool-installer").setup({ ensure_installed = vim.list_extend(required_lsps, formatters) })
		require("mason-lspconfig").setup({
			handlers = {
				function(lsp_name)
					local lsp_options = lsp_config[lsp_name] or {}
					lsp_options.capabilities =
						vim.tbl_deep_extend("force", {}, capabilities, lsp_options.capabilities or {})

					require("lspconfig")[lsp_name].setup(lsp_options)
				end,
			},
		})
	end,
}
