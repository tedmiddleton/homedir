set nomodeline

:let mapleader = ","


call plug#begin('~/.vim/plugged')

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
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'hashivim/vim-terraform'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }  

call plug#end()

packadd termdebug

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
"coc.nvim wants this for displaying messages
"set cmdheight=2
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
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
" Can't do this anymore because it interferes with the fzf terminal window
"if has('nvim')
"   tnoremap <C-l> <C-\><C-n><C-w><C-l>
"   tnoremap <C-j> <C-\><C-n><C-w><C-j>
"   tnoremap <C-k> <C-\><C-n><C-w><C-k>
"   tnoremap <C-h> <C-\><C-n><C-w><C-h>
"else
"   tnoremap <C-l> <C-w><C-l>
"   tnoremap <C-j> <C-w><C-j>
"   tnoremap <C-k> <C-w><C-k>
"   tnoremap <C-h> <C-w><C-h>
"endif
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-h> <ESC><C-w>h
tnoremap <C-w>n <C-w>N

"coc.nvim mappings and config

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" NOTE - this seems to be mapped by vim-julia
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"if has('patch8.1.1068')
"  " Use `complete_info` if your (Neo)Vim version supports it.
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

" Use `[g` and `]g` to navigate diagnostics. 
" These are the clangd warnings, for example.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" --- end of coc.nvim section

"Map Ctrl-N to start NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
"nnoremap <C-n> :CocCommand explorer<CR>

"Quit if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Vim slime
let g:slime_target = "tmux"
let g:slime_cell_delimiter = "#%%"
let g:slime_no_mappings = 1
"These need to be xmap/nmap because the author of vim-slime made the interface a 
" mapping, so xnoremap/nnoremap doesn't work properly.
xmap <C-c><C-c> <Plug>SlimeRegionSend
nmap <C-c><C-c> <Plug>SlimeParagraphSend
nmap <C-c>v <Plug>SlimeConfig<CR>
nmap <leader>s <Plug>SlimeSendCell
"xnoremap <C-c><C-c> :call slime#send_op(visualmode(), 1)<cr>
"nnoremap <C-c><C-c> :call slime#store_curpos()<cr>:set opfunc=slime#send_op<cr>g@ip
"nnoremap <C-c>v :call slime#config()<cr>
"nnoremap <leader>s :call slime#send_cell()<cr>

"Map F8 to Tagbar
nnoremap <F8> :TagbarToggle<CR>

"Some FZF remappings
nnoremap <C-y> :History<CR>
nnoremap <C-m> :FZF<cr>
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
"inoremap <C-c> <esc>
"noremap <C-c> <nop>
nnoremap df <esc>
inoremap df <esc>
vnoremap df <esc>
cnoremap df <C-c>

"Make it easy to open .vimrc
nnoremap <leader>ev :rightbelow vsplit $MYVIMRC<cr>
nnoremap <leader>wv :rightbelow vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>




