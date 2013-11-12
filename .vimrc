set ic
se nu
set autoindent
set nocompatible
set ruler
set showcmd
set laststatus=2
set ttyfast           " Indicates a fast terminal connection
"set statusline=%=%f\ \"%F\"\ %m%R\ [%4l(%3p%%):%3c-(0x%2B,\0%2b),%Y,%{&encoding}]
set statusline=%=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

set tabstop=2
set shiftwidth=2

" Bad... slows stuff down to a crawl
"filetype plugin indent on

" Do clever indent things. Don't make a # force column zero.
set autoindent
set smartindent
inoremap # X<BS>#

set smarttab
set expandtab
set hlsearch
set incsearch
set nowrap
set showfulltag
" Wrap on these
"set listchars+=precedes:<,extends:>
set whichwrap+=<,>,[,]

" Use the cool tab complete menu
set wildmenu
set wildignore=*.o,*~

"This is supposed to issue shortmessages in various situations
"I have no clue - from http://jmcantrell.me/files/vimrc.html
set shortmess=aTItoO
"             ||||||
"             |||||+-- Message for reading file overwrites previous
"             ||||+--- Don't prompt to overwrite file
"             |||+---- Truncate file at start if too long
"             ||+----- Disable intro message
"             |+------ Truncate messages in the middle if too long

set infercase  " Try to adjust insert completions for case
set completeopt=longest,menu,menuone
"               |       |    |
"               |       |    +-- Show popup even with one match
"               |       +------- Use popup menu with completions
"               +--------------- Insert longest completion match

set wildmenu  " Enable wildmenu for completion
set wildmode=longest:full,list:full
"            |            |
"            |            +-- List matches, complete first match
"            +--------------- Complete longest prefix, use wildmenu


" this makes the mouse paste a block of text without formatting it
" (good for code)
map <MouseMiddle> <esc>"*p

set splitright  " When splitting vertically, split to the right
set splitbelow  " When splitting horizontally, split below

"This enables windows shortcuts (so sue me)
"http://vim.wikia.com/wiki/Enabling_Windows_shortcuts_for_gvim
set winaltkeys=yes

"split management
set winheight=2 "even when minimized show two lines
"maximize split
map <C-J> <C-W>j<C-W>_  
"minimize split
map <C-K> <C-W>k<C-W>_
"reduce size by one line
map <C-M> <C-W>-


" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
end

"I'm so propah... I'm falling over meself
set lcs+=tab:▷⋅      " Right triangle and middle dot for tab chars
set lcs+=extends:›   " Right single angle for chars right of the screen
set lcs+=precedes:‹  " Left single angle for chars left of the screen
set lcs+=nbsp:·      " Middle dot for non-breaking spaces
set lcs+=trail:·     " Middle dot for trailing spaces

" Quickfix navigation
nmap <silent> gc :cnext<cr>
nmap <silent> gC :cprev<cr>

" Location list navigation
nmap <silent> gl :lnext<cr>
nmap <silent> gL :lprev<cr>

" Buffer navigation
nmap <silent> gb :bnext<cr>
nmap <silent> gB :bprev<cr>

" Jumplist navigation
nnoremap <silent> g<backspace> <c-o>
nnoremap <silent> g<return>    <c-i>

" Fix commas without a following space
nmap <silent> <leader>x, :%s/,\zs\ze[^\s]/ /gc<cr>
" Fix , with leading spaces
nmap <silent> <leader>x, :silent! %s/\s\+,/,/gc<cr>


 " turn off any existing search
au VimEnter * nohls

" Redraw screen and remove search highlights if u press ctrl-l
"Life Saver !!
nnoremap <silent> <c-l> :nohl<cr><c-l>

:nmap <C-p> :tabprevious<cr>
:nmap <C-n> :tabnext<cr>
":map <C-S-tab> :tabprevious<cr>
":map <C-tab> :tabnext<cr>
":imap <C-S-tab> <ESC>:tabprevious<cr>i
":imap <C-tab> <ESC>:tabnext<cr>i
":nmap <C-w> :tabclose<cr>
":imap <C-t> <ESC>:tabnew<cr>
:map <C-S-n> <ESC>:tabnew<cr>



"colors default
"syntax on
"set guifont=Consolas:h11:cANSI
"set guifont=Monaco\ 10
"set guifont=Terminus/12/-1/5/50/0/0/0/0/0
set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
"set guifont=Anonymous\ Pro\ 12
"set guifont=Inconsolata\ 12
"set guifont=Terminus\ 13
"colorscheme zenburn
"colorscheme inkpot
"colorscheme wombat 
"colorscheme sunburst
"colorscheme desert

"let g:molokai_original = 0
"colorscheme molokai

"colorscheme xoria256
"colorscheme inspiration694250
"colorscheme argonaut 

let g:sienna_style = 'dark'
colorscheme desert 

"make sure this section always comes AFTER colorscheme
" Without color scheme, set line colors to grey
"hi LineNr         ctermfg=DarkMagenta guifg=#2b506e guibg=#000000 
"hi LineNr    term=bold  guifg=#2b506e ctermfg=#2b506e guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi LineNr term=BOLD cterm=NONE ctermfg=darkgrey ctermbg=NONE guifg=#2b506e guibg=NONE

"set background=dark
"set g:solarized_termcolors=256
"colorscheme solarized


"the following comment functions allow you to highlight a section
" and press ,c (comma c) to comment and ,d (comma d) to uncomment
"comments will happen according to language

function! VHDLCommentMap()
vmap ,c :s/^/–/
vmap ,d :s/^–//
endfunction

function! VerilogCommentMap()
vmap ,c :s/^/\/\//
vmap ,d :s/^\/\///
endfunction

function! PythonCommentMap()
vmap ,c :s/^/#/
vmap ,d :s/^#//
endfunction

autocmd FileType vhdl call VHDLCommentMap()
autocmd FileType verilog,cpp,c call VerilogCommentMap()
autocmd FileType tcl,perl,python,ruby call PythonCommentMap()

"folding settings
"set foldmethod=indent   "fold based on indent
"set foldnestmax=3       "deepest fold is 3 levels
"set nofoldenable        "dont fold by default

"" Folding and unfolding
""map ,f :set foldmethod=indent<cr>zM<cr>
""map ,F :set foldmethod=manual<cr>zR<cr>

" Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc



" filetypes
au BufRead,BufNewFile *.pp            set filetype=puppet
au FileType puppet      set expandtab

" Auto-save on losing focus
au FocusLost * :wa

" in Ruby and Scala, we use spaces (two) instead of tabs
au BufRead,BufNewFile *.rb,*.scala,*.clj set et sw=2 sts=2 ts=2 expandtab
" in Python, we use spaces (four) instead of tabs
au BufRead,BufNewFile *.py set et
autocmd BufWrite *.py :call DeleteTrailingWS()
" these are re-specified to avoid issues with having files of different types
" open. there is probably a better way to do this. which is good, because this
" list of filetypes isn't anywhere near exhaustive.
au BufRead,BufNewFile *.css,*.c,*.java,*.html*,*.js set noet sw=4 sts=4 ts=4 


" up/down move between visual lines instead of actual lines when wrapped
"imap <silent> <Down> <C-o>gj
"imap <silent> <Up> <C-o>gk
"nmap <silent> <Down> gj
"nmap <silent> <Up> gk

" FuzzyFinder
let g:fuf_modesDisable = []
let g:fuf_enumeratingLimit = 30
let g:fuf_ignoreCase = 0
let g:fuf_keyOpenSplit = '<C-m>'


nnoremap ,ff :FufBuffer<CR>
nnoremap ,fi :FufFile<CR>
nnoremap ,fd :FufDir<CR>
nnoremap ,fm :FufMruFile<CR>
nnoremap ,fc :FufMruCmd<CR>
nnoremap ,fb :FufBookmark<CR>
nnoremap ,fa :FufAddBookmark<CR>
nnoremap ,ft :FufTag<CR>
nnoremap ,fg :FufTaggedFile<CR>
