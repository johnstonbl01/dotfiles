local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = { mappings = { i = { ["<esc>"] = actions.close } } },
	pickers = {
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
	},
})

local M = {}

local find_files = require("telescope.builtin").find_files
local git_branches = require("telescope.builtin").git_branches

M.search_dotfiles = function()
	find_files({
		prompt_title = "< dotfiles >",
		cwd = "~/dev/personal/dotfiles",
		hidden = true,
	})
end

M.git_branches = function()
	git_branches({
		attach_mappings = function(_, map)
			map("i", "<c-d>", actions.git_delete_branch)
			map("n", "<c-d>", actions.git_delete_branch)
			return true
		end,
	})
end

telescope.load_extension("fzf")

return M
