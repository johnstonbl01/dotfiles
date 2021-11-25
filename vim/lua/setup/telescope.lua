local telescope = require('telescope')

telescope.setup({
  pickers = {
    find_files = {
      -- Include hidden files except for .git
      find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
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

telescope.load_extension('fzf')