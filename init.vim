set nomodeline

:let mapleader = ","


if has('nvim')
call plug#begin(stdpath('data') . '/plugged')
else
call plug#begin('~/.vim/plugged')
endif

"Note - the following are two different plugins (!!!)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'derekwyatt/vim-fswitch'
Plug 'lifepillar/vim-solarized8'
Plug 'rust-lang/rust.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'jpalardy/vim-slime'
Plug 'tpope/vim-repeat'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'hashivim/vim-terraform'
Plug 'neovim/nvim-lspconfig'
Plug 'mhinz/vim-startify'
Plug 'sbdchd/neoformat'

call plug#end()

packadd termdebug

" Lua config - into lua-land!
if has('nvim')
lua << EOF

require 'lspconfig'.clangd.setup{}
local nvim_lsp = require 'lspconfig'

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
endif
" end of lua config

filetype plugin indent on

set mouse=a
if !has('nvim')
set ttymouse=sgr
endif
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set hidden
set ignorecase
set smartcase
set autoindent
set incsearch
set ruler
set textwidth=80
set history=1000
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

" Ugly work-around for not having +clipboard compiled in 
if !has('clipboard')
    "Wayland clipboard
    if executable( 'wl-copy' )
        xnoremap "+y y:call system("wl-copy", @")<cr>
        nnoremap "+yy yy:call system("wl-copy", @")<cr>
        nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
        nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
    endif
endif

" Make window navigation easier. Especially important in neovim to avoid getting
" trapped in a terminal window.
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-h> <ESC><C-w>h
tnoremap <C-w>n <C-w>N

"Map Ctrl-N to start NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

"Quit if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Neoformat
let g:neoformat_enabled_cpp = ['clangformat']

"Vim slime
let g:slime_target = "tmux"
let g:slime_cell_delimiter = "#%%"
let g:slime_no_mappings = 1
xmap <C-c><C-c> <Plug>SlimeRegionSend
nmap <C-c><C-c> <Plug>SlimeParagraphSend
nmap <C-c>v <Plug>SlimeConfig<CR>
nmap <leader>s <Plug>SlimeSendCell

"Map F8 to Tagbar
nnoremap <F8> :TagbarToggle<CR>

"Some FZF remappings
nnoremap <C-y> :History<CR>
nnoremap <C-j> :FZF<cr>
nnoremap <C-x> :Buffers<cr>
nnoremap <C-p> :Ag<cr>

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
nnoremap df <esc>
inoremap df <esc>
vnoremap df <esc>
cnoremap df <C-c>

"Make it easy to open .vimrc
nnoremap <leader>ev :rightbelow vsplit $MYVIMRC<cr>
nnoremap <leader>wv :rightbelow vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


