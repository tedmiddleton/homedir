vim.g.mapleader = ","

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(
  function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Example plugins
    --use 'tpope/vim-sensible'                -- Example basic Vim settings
    use 'ibhagwan/fzf-lua'
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
    use 'echasnovski/mini.pairs'
    use 'folke/ts-comments.nvim'
    use 'echasnovski/mini.ai'
    use 'MagicDuck/grug-far.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Add other plugins as you like
  end
)

require('grug-far').setup()
require('mini.pairs').setup()

local nvim_lsp = require('lspconfig')
local FzfLua = require('fzf-lua')
nvim_lsp.clangd.setup{}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { buffer=bufnr, noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions

  --vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt)
  vim.keymap.set("n", "gD", FzfLua.lsp_declarations, opt)
  --vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt)
  vim.keymap.set("n", "gd", FzfLua.lsp_definitions, opt)
  --vim.keymap.set("n", "gr", vim.lsp.buf.references, opt)
  vim.keymap.set("n", "gr", FzfLua.lsp_references, opt)
  --vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opt)
  vim.keymap.set("n", "gi", FzfLua.lsp_implementations, opt)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opt)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opt)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opt)
  --vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opt)
  vim.keymap.set("n", "<space>ca", FzfLua.lsp_code_actions, opt)
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opt)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opt)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opt)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opt)
  vim.keymap.set("n", "<space>f", vim.lsp.buf.format, opt)

  -- It's just too much
  if client.name == 'basedpyright' then
    vim.diagnostic.config({ virtual_text = false })
  end
  -- TODO
  -- beginning of function
  -- end of function
  -- what else?
  -- class definition - methods and fields
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'basedpyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})
---ENDWORKAROUND

local function find_file_in_parent_dirs(filename)
  -- Start from the directory of the current file
  local dir = vim.fn.getcwd()

  --print("Starting the search for compile_commands.json at: " .. dir)
  while dir ~= "/" do
    local path = dir .. "/" .. filename
    --print("Checking for compile_commands.json at: " .. path)
    if vim.fn.filereadable(path) == 1 then
      --print("Found compile_commands.json at: " .. path)
      return dir
    end
    if vim.fn.isdirectory(path) == 1 then
      --print("Found compile_commands.json at: " .. path)
      return dir
    end
    -- Move up one directory
    dir = vim.fn.fnamemodify(dir, ":h")
  end

  --print("compile_commands.json not found.")
  return nil
end

local function find_project_root()
  local compile_commands_path = find_file_in_parent_dirs("compile_commands.json")
  if compile_commands_path ~= nil then
    return compile_commands_path
  end

  -- We couldn't find compile_commands.json in the direct path, so try 
  -- CMakeLists.txt
  local cmake_path = find_file_in_parent_dirs("CMakeLists.txt")
  if cmake_path ~= nil then
    return cmake_path
  end

  -- A .git directory is a good indicator of a project root
  local git_path = find_file_in_parent_dirs(".git")
  if git_path ~= nil then
    return git_path
  end

  -- We couldn't find either so we'll just return the current directory
  return vim.fn.getcwd()
end

-- Run the function to print the path or use it as needed
project_root = find_project_root()

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Set options
vim.opt.mouse = "a"
if not vim.fn.has("nvim") then
vim.opt.ttymouse = "sgr"
end
-- Makes the Tab key (and backspace) feel like it inserts/removes N spaces or 
-- tabs; if noexpandtab is set, it will use actual tab characters
vim.opt.softtabstop = 2
-- Determines the number of spaces (or tabs, if noexpandtab is set) used for 
-- each level of indentation, e.g., when auto-indenting or using > or < commands
vim.opt.shiftwidth = 2
-- expandtab (the default in many distributions) means that each time you press 
-- the Tab key, Neovim inserts spaces.
-- noexpandtab ensures pressing Tab inserts a literal \t character
vim.opt.expandtab = true
-- Sets the width (in spaces) that a tab character occupies. This is purely 
-- visual and does not change how files are saved—tabs will still be tabs, but 
-- displayed as if they were N spaces wide.
vim.opt.tabstop = 8
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
vim.filetype.add({
  extension = {
    aj = "java",
    cu = "cpp",
    rl = "cpp",
    ts = "javascript",
    rs = "rust"
  }
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

-- FZF remappings. Different now.
vim.keymap.set("n", "<C-i>", FzfLua.oldfiles)
vim.keymap.set("n", "<C-y>", FzfLua.buffers)
vim.keymap.set("n", "<C-j>", 
  function()
    FzfLua.files({cwd = project_root})
  end)
vim.keymap.set("n", "<C-p>", 
  function()
    FzfLua.live_grep({cwd = project_root})
  end)
vim.keymap.set("n", "<C-m>", FzfLua.lsp_workspace_symbols)

-- Set tags - the last semicolon is important so that vim searches up the 
-- directory tree
vim.opt.tags = "./tags;"

-- vim-fswitch settings
local header_pat = 'reg:|src|inc|,reg:|src|include|,reg:|src|inc/**|,reg:|src|include/**|'
local source_pat = 'reg:|include|src,reg:|inc|src,reg:|include.*|src|,reg:|inc.*|src|,ifrel:|/include/|../src|,ifrel:|/inc/|../src|'

-- Define autocmds for fswitch
local fswitch_autocmd = function(filetype, dst, locs)
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*." .. filetype,
    callback = function()
      vim.b.fswitchdst = dst
      vim.b.fswitchlocs = locs
    end
  })
end

fswitch_autocmd("cpp", "hpp,hh,h", header_pat)
fswitch_autocmd("cc", "hh,hpp,h", header_pat)
fswitch_autocmd("c", "h", header_pat)
fswitch_autocmd("rl", "hh,hpp", header_pat)
fswitch_autocmd("hpp", "cpp,cc", source_pat)
fswitch_autocmd("hh", "cc,cpp,rl", source_pat)
fswitch_autocmd("h", "cpp,cc,c", source_pat)

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







