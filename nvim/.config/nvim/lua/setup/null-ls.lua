local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- auto-format for rust
vim.cmd([[ autocmd BufWritePre *.rs lua vim.lsp.buf.format() ]])

null_ls.setup({
	sources = {
		-- js / ts
		null_ls.builtins.formatting.prettier,
		-- lua
		null_ls.builtins.formatting.stylua,
		-- bash
		null_ls.builtins.formatting.shfmt.with({
			filetypes = { "sh", "zsh" },
		}),
		-- css
		null_ls.builtins.diagnostics.stylelint,
		null_ls.builtins.formatting.stylelint,
		-- docker
		null_ls.builtins.diagnostics.hadolint,
		-- go
		null_ls.builtins.formatting.goimports,
		-- html
		null_ls.builtins.diagnostics.markuplint,
		-- markdown
		null_ls.builtins.diagnostics.markdownlint,
		-- yaml
		null_ls.builtins.diagnostics.yamllint,
		-- sql
		null_ls.builtins.diagnostics.sqlfluff.with({
			extra_args = { "--dialect", "postgres" },
		}),
		null_ls.builtins.formatting.sqlfluff.with({
			extra_args = { "--dialect", "postgres" },
		}),
		-- spelling
		null_ls.builtins.diagnostics.codespell,
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
				end,
			})
		end
	end,
})
