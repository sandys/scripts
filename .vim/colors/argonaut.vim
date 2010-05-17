" Generated by Inspiration at Sweyla
" http://inspiration.sweyla.com/code/

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "inspiration-951824"

if version >= 700
  hi CursorLine guibg=#040F00
  hi CursorColumn guibg=#040F00
  hi MatchParen guifg=#F0FFC0 guibg=#040F00 gui=bold
  hi Pmenu 		guifg=#FFFFFF guibg=#323232
  hi PmenuSel 	guifg=#FFFFFF guibg=#9CFF65
endif

" General colors
hi Cursor       guifg=NONE guibg=#FFFFFF gui=none
hi Normal       guifg=#FFFFFF guibg=#040F00 gui=none
hi NonText      guifg=#FFFFFF guibg=#040F00 gui=none
hi LineNr       guifg=#FFFFFF guibg=#323232 gui=none
hi Normal       guifg=#FFFFFF guibg=#040F00 gui=none
hi StatusLine   guifg=#FFFFFF guibg=#040F00 gui=italic
hi StatusLineNC guifg=#FFFFFF guibg=#040F00 gui=none
hi VertSplit    guifg=#FFFFFF guibg=#040F00 gui=none
hi Folded       guifg=#FFFFFF guibg=#040F00 gui=none
hi Title		guifg=#9CFF65 guibg=NONE	gui=bold
hi Visual		guifg=#F0FFC0 guibg=#323232 gui=none
hi SpecialKey	guifg=#A4C551 guibg=#323232 gui=none

" Syntax highlighting
hi Comment guifg=#9CFF65 gui=none
hi Constant guifg=#A4C551 gui=none
hi Number guifg=#A4C551 gui=none
hi Identifier guifg=#A5AAFF gui=none
hi Statement guifg=#A5AAFF gui=none
hi Function guifg=#E6EDB6 gui=none
hi Special guifg=#55FF97 gui=none
hi PreProc guifg=#55FF97 gui=none
hi Keyword guifg=#F0FFC0 gui=none
hi String guifg=#5EFF24 gui=none
hi Type guifg=#E0E3C3 gui=none
