local map = vim.keymap.set

return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden" },
				},
				oldfiles = {
					cwd_only = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		map(
			"n",
			"<Leader>ff",
			[[<cmd>lua require('telescope.builtin').find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind [F]iles" }
		)

		map(
			"n",
			"<Leader>fg",
			[[:Telescope live_grep<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind by [G]rep" }
		)

		map(
			"n",
			"<Leader>fb",
			[[:Telescope buffers<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind in [B]uffer" }
		)

		map(
			"n",
			"<Leader>fd",
			[[<cmd>lua require('setup.telescope').search_dotfiles()<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind in [D]otfiles" }
		)

		map(
			"n",
			"<Leader>fr",
			[[:Telescope git_branches<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind git b[R]anch" }
		)

		map(
			"n",
			"<Leader>fo",
			[[:Telescope oldfiles<CR>]],
			{ noremap = true, silent = true, desc = "[F]ind [O]ld file" }
		)

		map(
			"n",
			"<Leader>sh",
			[[:Telescope help_tags<CR>]],
			{ noremap = true, silent = true, desc = "[S]earch [H]elp" }
		)

		map(
			"n",
			"<Leader>sd",
			[[:Telescope diagnostics<CR>]],
			{ noremap = true, silent = true, desc = "[S]earch [D]iagnostics" }
		)
	end,
}
