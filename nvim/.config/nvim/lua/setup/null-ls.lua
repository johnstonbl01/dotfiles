local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- auto-format for rust
vim.cmd([[ autocmd BufWritePre *.rs lua vim.lsp.buf.format() ]])

null_ls.setup({
	sources = {
		-- js / ts
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.prettier,
		-- lua
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.formatting.stylua,
		-- python
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.formatting.ruff,
		-- bash
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.beautysh,
		-- css
		null_ls.builtins.diagnostics.stylelint,
		-- docker
		null_ls.builtins.diagnostics.hadolint,
		-- go
		null_ls.builtins.diagnostics.revive,
		null_ls.builtins.formatting.goimports,
		-- html
		null_ls.builtins.diagnostics.markuplint,
		-- json
		null_ls.builtins.diagnostics.jsonlint,
		-- markdown
		null_ls.builtins.diagnostics.markdownlint,
		-- rust
		null_ls.builtins.formatting.rustfmt,
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
		null_ls.builtins.diagnostics.typos,
		null_ls.builtins.diagnostics.misspell,
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
