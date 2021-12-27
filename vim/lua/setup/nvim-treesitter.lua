local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
  autotag = {
    enable = true
  },
  context_commentstring = {
    enable = true,
  },
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
})
