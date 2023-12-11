local lualine = require("lualine")

lualine.setup({
	options = { theme = "duskfox" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{ "diagnostics", sources = { "nvim_diagnostic" } },
		},
		lualine_c = { { "filename", file_status = true, path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
