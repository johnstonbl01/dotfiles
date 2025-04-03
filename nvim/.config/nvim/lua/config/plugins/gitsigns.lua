return {
	"lewis6991/gitsigns.nvim",
	enable = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitsigns").setup({
			current_line_blame = true,
		})
	end,
}
