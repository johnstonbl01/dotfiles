vim.cmd([[
  augroup JsonC
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END
]])

