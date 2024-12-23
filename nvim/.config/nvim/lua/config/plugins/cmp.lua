return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{
			-- TODO: enable snippets for language servers like css / html, etc
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
	},
	config = function()
		require("luasnip").config.setup({})

		require("cmp").setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					col_offset = -3,
					side_padding = 0,
				},
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
			mapping = require("cmp").mapping.preset.insert({
				["<C-d>"] = require("cmp").mapping.scroll_docs(-4),
				["<C-u>"] = require("cmp").mapping.scroll_docs(4),

				["<CR>"] = require("cmp").mapping.confirm({ select = true }),
				["<Tab>"] = require("cmp").mapping.select_next_item(),
				["<S-Tab>"] = require("cmp").mapping.select_prev_item(),

				-- Manually trigger a completion from nvim-cmp.
				["<C-Space>"] = require("cmp").mapping.complete({}),
			}),
			sources = {
				{
					name = "lazydev",
					-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					group_index = 0,
					max_item_count = 10,
				},
				{ name = "nvim_lsp", max_item_count = 5 },
				{ name = "luasnip", max_item_count = 10 },
				{ name = "path", max_item_count = 10 },
			},
		})
	end,
}
