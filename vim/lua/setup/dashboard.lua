local db = require('dashboard')

db.custom_footer = {'Build some shit'}

db.custom_center = {
  {
    icon = '  ',
    desc = 'Find file               ',
    shortcut = '<space>ff',
    action = ':Telescope find_files'
  },
  {
    icon = '  ',
    desc = 'Recent files            ',
    shortcut = '<space>fo',
    action = ':Telescope oldfiles'
  },
  {
    icon = '  ',
    desc = 'New file                ',
    shortcut = '<space>cn',
    action = ':DashboardNewFile'
  },
}

db.custom_header = {
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
  }

