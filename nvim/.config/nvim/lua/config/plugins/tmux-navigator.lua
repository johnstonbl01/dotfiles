return {
	"christoomey/vim-tmux-navigator",
	config = function()
		vim.keymap.set("n", "<c-k>", [[:TmuxNavigateUp<CR>]], { silent = true })
		vim.keymap.set("n", "<c-j>", [[:TmuxNavigateDown<CR>]], { silent = true })
		vim.keymap.set("n", "<c-h>", [[:TmuxNavigateLeft<CR>]], { silent = true })
		vim.keymap.set("n", "<c-l>", [[:TmuxNavigateRight<CR>]], { silent = true })
	end,
}
