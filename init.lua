vim.g.mapleader = ","

require('packer').startup(
  function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Example plugins
    --use 'tpope/vim-sensible'                -- Example basic Vim settings
    use { 'junegunn/fzf', run = 'fzf#install()' }  -- Fuzzy Finder
    use 'junegunn/fzf.vim'                    -- FZF Vim integration
    use 'preservim/nerdtree'                  -- File tree explorer
    use 'majutsushi/tagbar'
    use 'derekwyatt/vim-fswitch'
    use 'lifepillar/vim-solarized8'
    use 'rust-lang/rust.vim'
    use 'JuliaEditorSupport/julia-vim'
    use 'jpalardy/vim-slime'
    use 'tpope/vim-repeat'
    use 'inkarkat/vim-ingo-library'
    use 'inkarkat/vim-mark'
    use 'hashivim/vim-terraform'
    use 'neovim/nvim-lspconfig'
    use 'mhinz/vim-startify'
    use 'sbdchd/neoformat'
    use 'p00f/clangd_extensions.nvim'
    use 'github/copilot.vim'
    use 'ojroques/nvim-lspfuzzy'

    -- Add other plugins as you like
  end
)

require 'lspconfig'.clangd.setup{}
local nvim_lsp = require 'lspconfig'
require('lspfuzzy').setup {}

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
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
-- TODO
-- beginning of function
-- end of function
-- what else?
-- class definition - methods and fields
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local function find_compile_commands()
  -- Start from the directory of the current file
  local dir = vim.fn.getcwd()

  --print("Starting the search for compile_commands.json at: " .. dir)
  while dir ~= "/" do
    local compile_commands_path = dir .. "/compile_commands.json"
    --print("Checking for compile_commands.json at: " .. compile_commands_path)
    if vim.fn.filereadable(compile_commands_path) == 1 then
      --print("Found compile_commands.json at: " .. compile_commands_path)
      return compile_commands_path
    end
    -- Move up one directory
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  --print("compile_commands.json not found.")
  return nil
end

-- Run the function to print the path or use it as needed
local project_root = find_compile_commands()

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Set options
vim.opt.mouse = "a"
if not vim.fn.has("nvim") then
vim.opt.ttymouse = "sgr"
end
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.ruler = true
vim.opt.textwidth = 80
vim.opt.history = 1000

-- Recognize numbered lists
vim.opt.formatoptions:append("n")
-- Remove comment leader when joining lines where it makes sense
vim.opt.formatoptions:append("j")
-- Automatically insert the current comment leader after hitting <Enter> in Insert mode
vim.opt.formatoptions:append("r")
-- Trailing whitespace indicates a paragraph continues on the next line
vim.opt.formatoptions:append("w")
-- Disable automatic line breaking in insert mode
vim.opt.formatoptions:remove("l")
-- Use the indent of the second line of a paragraph for subsequent lines
vim.opt.formatoptions:append("2")

-- Disable wrap scan
vim.opt.wrapscan = false

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Set filetypes for specific extensions
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
pattern = "*.aj",
command = "set filetype=java"
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
pattern = "*.rl",
command = "set filetype=cpp"
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
pattern = "*.cu",
command = "set filetype=cpp"
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
pattern = "*.ts",
command = "set filetype=javascript"
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
pattern = "*.rs",
command = "set textwidth=100 tags=./rusty-tags.vi;/"
})

-- Enable C indentation
vim.opt.cindent = true

-- Set C indentation options
-- :0 means 0 indentation for case in switch
-- N-s means 0 indentation for inside namespace
-- g0 means 0 indentation for public: etc in class
-- (s means indent s sw in statement.
vim.opt.cinoptions = ":0,N-s,g0,(0,Ws"

vim.g.pyindent_open_paren = "&sw"

-- Map Ctrl-N to start NERDTree
vim.api.nvim_set_keymap("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true, silent = true })

-- Quit if only NERDTree is open
vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*",
command = "if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif"
})

-- Neoformat
vim.g.neoformat_enabled_cpp = { "clangformat" }

-- Vim Slime
vim.g.slime_target = "tmux"
vim.g.slime_cell_delimiter = "#%%"
vim.g.slime_no_mappings = 1
vim.api.nvim_set_keymap("x", "<C-c><C-c>", "<Plug>SlimeRegionSend", {})
vim.api.nvim_set_keymap("n", "<C-c><C-c>", "<Plug>SlimeParagraphSend", {})
vim.api.nvim_set_keymap("n", "<C-c>v", "<Plug>SlimeConfig<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>s", "<Plug>SlimeSendCell", { noremap = true, silent = true })

-- Map F8 to Tagbar
vim.api.nvim_set_keymap("n", "<F8>", ":TagbarToggle<CR>", { noremap = true, silent = true })

-- FZF remappings
vim.api.nvim_set_keymap("n", "<C-y>", ":History<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":FZF<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":Ag<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-m>", ":Tags<CR>", { noremap = true, silent = true })

-- Set tags - the last semicolon is important so that vim searches up the 
-- directory tree
vim.opt.tags = "./tags;"

-- vim-fswitch settings
local header_pat = 'reg:|src|inc|,reg:|src|include|,reg:|src|inc/**|,reg:|src|include/**|'
local source_pat = 'reg:|include|src,reg:|inc|src,reg:|include.*|src|,reg:|inc.*|src|,ifrel:|/include/|../src|,ifrel:|/inc/|../src|'

-- Define autocmds for fswitch
vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.cpp",
callback = function()
vim.b.fswitchdst = "hpp,hh,h"
vim.b.fswitchlocs = header_pat
end
})

vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.cc",
callback = function()
vim.b.fswitchdst = "hh,hpp,h"
vim.b.fswitchlocs = header_pat
end
})

vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.c",
callback = function()
vim.b.fswitchdst = "h"
vim.b.fswitchlocs = header_pat
end
})

vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.hpp",
callback = function()
vim.b.fswitchdst = "cpp,cc"
vim.b.fswitchlocs = source_pat
end
})

vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.hh",
callback = function()
vim.b.fswitchdst = "cc,cpp"
vim.b.fswitchlocs = source_pat
end
})

vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*.h",
callback = function()
vim.b.fswitchdst = "cpp,cc,c"
vim.b.fswitchlocs = source_pat
end
})


-- Map Ctrl-A to FSHere command
vim.api.nvim_set_keymap("n", "<C-a>", ":FSHere<CR>", { noremap = true, silent = true })

-- vim-cmake and cargo settings
vim.g.cmake_build_dir = "_build"
vim.g.cargo_makeprg_params = "build"
vim.g.rust_cargo_avoid_whole_workspace = 0

-- Enable true color support if termguicolors is available
if vim.fn.exists("+termguicolors") == 1 then
--  vim.opt.t_8f = "\27[38;2;%lu;%lu;%lum"
--  vim.opt.t_8b = "\27[48;2;%lu;%lu;%lum"
vim.opt.termguicolors = true
end

-- Set background to dark and apply the solarized8 colorscheme
vim.opt.background = "dark"
vim.cmd("colorscheme solarized8")

-- Map 'df' as an easy escape replacement in different modes
vim.api.nvim_set_keymap("n", "df", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "df", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "df", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "df", "<C-c>", { noremap = true, silent = true })

-- Quick access to .vimrc (or init.lua) for editing, sourcing, and saving
vim.api.nvim_set_keymap("n", "<leader>ev", ":rightbelow vsplit $MYVIMRC<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>wv", ":rightbelow vsplit $MYVIMRC<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>sv", ":source $MYVIMRC<CR>", { noremap = true, silent = true })







