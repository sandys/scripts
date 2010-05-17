"=
" cream-colors-terminal.vim
"
" Cream -- An easy-to-use configuration of the famous Vim text editor
" [ http://cream.sourceforge.net ] Copyright (C) 2001-2007  Steve Hall
"
" License:
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 3 of the License, or
" (at your option) any later version.
" [ http://www.gnu.org/licenses/gpl.html ]
"
" This program is distributed in the hope that it will be useful, but
" WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
" General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software
" Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
" 02111-1307, USA.
"

set background=dark
highlight clear
if exists("syntax_on")
	syntax reset
endif

" force reverse
highlight Normal guibg=Black guifg=White

"let g:colors_name = "cream"

"+++ Cream:

" statusline
highlight User1  gui=bold guifg=#999999 guibg=#404040
highlight User2  gui=bold guifg=#ffffff guibg=#404040
highlight User3  gui=bold guifg=#ffff00 guibg=#404040
highlight User4  gui=bold guifg=#ff3333 guibg=#404040

" bookmarks
highlight Cream_ShowMarksHL gui=bold guifg=#ffff00 guibg=#5f5f00 ctermfg=blue ctermbg=lightblue cterm=bold

" spell check
highlight BadWord gui=bold guifg=#ffffff guibg=#663333 ctermfg=black ctermbg=lightblue

" current line
highlight CurrentLine term=reverse ctermbg=0 ctermfg=14 gui=none guibg=#666666

" email
highlight EQuote1 guifg=#ffff33
highlight EQuote2 guifg=#cccc33
highlight EQuote3 guifg=#999933
highlight Sig guifg=#999999

"+++

