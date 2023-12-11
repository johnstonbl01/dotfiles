local comment = require("Comment")

require("ts_context_commentstring").setup({})

comment.setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})

vim.cmd([[
  augroup JsonC
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END
]])
