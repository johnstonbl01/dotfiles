local g = vim.g

g.dashboard_default_executive = 'telescope'
g.dashboard_custom_footer = {'Build some shit'}
g.dashboard_custom_section = {
  find_file = {
    description = { '  Find file               <space>ff' },
    command = ':Telescope find_files'
  },
  recent_files = {
    description = { '  Recent files            <space>fo' },
    command = ':Telescope oldfiles'
  },
  new_file = {
    description = { '  New file                <space>cn' },
    command = ':DashboardNewFile'
  },
}
g.dashboard_custom_header = {
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

