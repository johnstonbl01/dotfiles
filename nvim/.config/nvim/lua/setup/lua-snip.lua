local map = vim.keymap.set

local ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({
	history = true,
	enable_autosnippets = true,
})

map({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })
map({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true })

map({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
