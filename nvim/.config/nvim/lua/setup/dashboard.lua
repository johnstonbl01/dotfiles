local db = require('dashboard')

-- icons from https://github.com/ziontee113/icon-picker.nvim/blob/master/lua/icon-picker/icons/nf-icon-list.lua
db.setup({
    theme = 'hyper',
    config = {
        header = {
            '      .    .     .            +         .         .                 .  .',
            '       .                 .                   .               .          ',
            '              .    ,,o         .                  __.o+.                ',
            '    .            od8^                  .      oo888888P^b           .   ',
            '       .       ,".o\'      .     .             `b^\'""`b -`b   .          ',
            '              ,\'.\'o\'             .   .          t. = -`b -`t.    .      ',
            '             ; d o\' .        ___          _.--.. 8  -  `b  =`b          ',
            '         .  dooo8<       .o:\':__;o.     ,;;o88%%8bb - = `b  =`b.    .   ',
            '     .     |^88^88=. .,x88/::/ | \\`;;;;;;d%%%%%88%88888/%x88888        ',
            '           :-88=88%%L8`%`|::|_>-<_||%;;%;8%%=;:::=%8;;\\%%%%\\8888        ',
            '       .   |=88 88%%|HHHH|::| >-< |||;%;;8%%=;:::=%8;;;%%%%+|]88        .',
            '           | 88-88%%LL.%.%b::Y_|_Y/%|;;;;`%8%%oo88%:o%.;;;;+|]88  .     ',
            '           Yx88o88^^\'"`^^%8boooood..-\\H_Hd%P%%88%P^%%^\'\\;;;/%%88        ',
            '          . `"\\^\\          ~"""""\'      d%P """^" ;   = `+\' - P         ',
            '    .        `.`.b   .                :<%%>  .   :  -   d\' - P      . . ',
            '               .`.b     .        .    `788      ,\'-  = d\' =.\'          ',
            '        .       ``.b.                           :..-  :\'  P            ',
            '             .   `q.>b         .               `^^^:::::,\'       .      ',
            '                   ""^^               .                     .           ',
            '   .                                           .               .       .',
            '     .         .          .                 .        +         .        ',
            '', '', ''
        },
        packages = {enable = true},
        project = {limit = 5, label = '', action = 'Telescope find_files cwd='},
        mru = {limit = 5, label = ''},
        shortcut = {
            {
                desc = ' Find file',
                key = 'f',
                action = ':Telescope find_files',
                group = 'Label'
            }, {
                desc = ' Recent files',
                key = 'o',
                action = ':Telescope oldfiles',
                group = 'DiagnosticHint'
            }, {
                desc = ' Git branches',
                key = 'g',
                action = ':Telescope git_branches',
                group = 'Number'
            }
        },
        footer = {'', '', '', '👾 Build cool shit 👾'}
    }
})
