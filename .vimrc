set nomodeline

:let mapleader = ","

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'derekwyatt/vim-fswitch'
Plug 'lifepillar/vim-solarized8'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rust-lang/rust.vim'
Plug 'jnwhiteh/vim-golang'
Plug 'junegunn/fzf'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
"Plug 'inkarkat/vim-mark'
if executable( 'cmake' )
   Plug 'vhdirk/vim-cmake'
endif
Plug 'neoclide/coc.nvim', { 'branch': 'release' }  
"Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'} 

call plug#end()

filetype plugin indent on

set mouse=a
set ttymouse=sgr
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set ignorecase
set smartcase
set autoindent
set incsearch
set ruler
set textwidth=80
"Recognize numbered lists
set formatoptions+=n
"Where it makes sense, remove a comment leader when joining lines
set formatoptions+=j
"Automatically insert the current comment leader after hitting <Enter> in Insert
"mode
set formatoptions+=r
"Trailing white space indicates a paragraph continues in the next line.  A line
"that ends in a non-white character ends a paragraph.
set formatoptions+=w
"Turning this off means long lines WILL be broken in insert mode
set formatoptions-=l
"When formatting text, use the indent of the second line of a paragraph for the
"rest of the paragraph, instead of the indent of the first line.
set formatoptions+=2
set nowrapscan
"Syntax highlighting
syntax enable

autocmd BufNewFile,BufRead *.aj set filetype=java
autocmd BufNewFile,BufRead *.ts set filetype=javascript
autocmd BufNewFile,BufRead *.rs set textwidth=100 tags=./rusty-tags.vi;/

"C indentation options
" :0 means 0 indentation for case in switch
" N-s means 0 indentation for inside namespace
" g0 means 0 indentation for public: etc in class
" (s means indent s sw in statement.
set cinoptions=:0,N-s,g0,(0,Ws
let g:pyindent_open_paren = "&sw"

if has('gui_running')
   if has('macunix')
      set guifont=Menlo:h12
   else
      set guifont=
   endif
endif

" Make window navigation easier. Especially important in neovim to avoid getting
" trapped in a terminal window.
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
if has('nvim')
   tnoremap <C-l> <C-\><C-n><C-w><C-l>
   tnoremap <C-j> <C-\><C-n><C-w><C-j>
   tnoremap <C-k> <C-\><C-n><C-w><C-k>
   tnoremap <C-h> <C-\><C-n><C-w><C-h>
else
   tnoremap <C-l> <C-w><C-l>
   tnoremap <C-j> <C-w><C-j>
   tnoremap <C-k> <C-w><C-k>
   tnoremap <C-h> <C-w><C-h>
endif
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-h> <ESC><C-w>h
tnoremap <C-w>n <C-w>N

"Map Ctrl-N to start NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
"nnoremap <C-n> :CocCommand explorer<CR>

"Quit if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Map F8 to Tagbar
nnoremap <F8> :TagbarToggle<CR>

"Various ctrlp.vim settings
let g:ctrlp_extensions = ['quickfix']
let g:ctrlp_max_files=0
let g:ctrlp_match_window = 'max:10,results:60'
let g:ctrlp_types = [ 'buf', 'mru' ]

nnoremap <C-m> :FZF<cr>

set tags=./tags;

"vim-fswitch settings. Had to add the .h setting because it won't switch to
".cpp files without it?
let header_pat = 'reg:|src|inc|,reg:|src|include|,reg:|src|inc/**|,reg:|src|include/**|'
let source_pat = 'reg:|include|src,reg:|inc|src,reg:|include.*|src|,reg:|inc.*|src|,ifrel:|/include/|../src|,ifrel:|/inc/|../src|'
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = header_pat
au! BufEnter *.c let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = header_pat
au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs = source_pat
au! BufEnter *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = source_pat
au! BufEnter *.tin let b:fswitchdst = 'tac' | let b:fswitchlocs = header_pat
au! BufEnter *.tac let b:fswitchdst = 'tin' | let b:fswitchlocs = source_pat

nnoremap <C-a> :FSHere<cr>

"vim-cmake default to _build
let g:cmake_build_dir = '_build'

let g:cargo_makeprg_params = 'build'
let g:rust_cargo_avoid_whole_workspace = 0

if exists( '+termguicolors' )
   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
   set termguicolors
endif
set background=dark
colorscheme solarized8

set pastetoggle=<F2>

"Make various things into an escape - escape is too hard to press, as is the
"awful <C-[>
"inoremap <C-c> <esc>
"noremap <C-c> <nop>
nnoremap df <esc>
inoremap df <esc>
vnoremap df <esc>
cnoremap df <C-c>

"Make it easy to open .vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>wv :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>




