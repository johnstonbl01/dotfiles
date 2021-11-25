vim.cmd([[
  augroup JsonC
    autocmd!
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END 
]])

vim.cmd([[
  augroup PackerConfig
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd([[
  augroup 
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup end
]])