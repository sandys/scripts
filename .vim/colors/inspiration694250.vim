" Generated by Inspiration at Sweyla
" http://inspiration.sweyla.com/code/

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "inspiration-694250"

if version >= 700
  hi CursorLine guibg=#000000
  hi CursorColumn guibg=#000000
  hi MatchParen guifg=#C6A09E guibg=#000000 gui=bold
  hi Pmenu 		guifg=#FFFFFF guibg=#323232
  hi PmenuSel 	guifg=#FFFFFF guibg=#C853F8
endif

" General colors
hi Cursor       guifg=NONE guibg=#FFFFFF gui=none
hi Normal       guifg=#FFFFFF guibg=#000000 gui=none
hi NonText      guifg=#FFFFFF guibg=#000000 gui=none
hi LineNr       guifg=#FFFFFF guibg=#323232 gui=none
hi Normal       guifg=#FFFFFF guibg=#000000 gui=none
hi StatusLine      guifg=#883600 guibg=#ccdc90
hi StatusLineNC    guifg=#3f3f3f guibg=#88b090
hi VertSplit       guifg=#2e3330 guibg=#688060
hi Folded       guifg=#FFFFFF guibg=#000000 gui=none
hi Title		guifg=#C853F8 guibg=NONE	gui=bold
hi Visual		guifg=#C6A09E guibg=#323232 gui=none
hi SpecialKey	guifg=#FFF31C guibg=#323232 gui=none

" Syntax highlighting
hi Comment guifg=#C853F8 gui=none
hi Constant guifg=#FFF31C gui=none
hi Number guifg=#FFF31C gui=none
hi Identifier guifg=#FF009C gui=none
hi Statement guifg=#FF009C gui=none
hi Function guifg=#FFD424 gui=none
hi Special guifg=#4AA072 gui=none
hi PreProc guifg=#4AA072 gui=none
hi Keyword guifg=#C6A09E gui=none
hi String guifg=#FF8034 gui=none
hi Type guifg=#FF475B gui=none
