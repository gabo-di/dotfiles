" ==========================================================
" Minimal Vim configuration for servers / SSH / tmux
" Focus:
"   - Recursive file finding (:find)
"   - Project-wide search (:grep)
"   - Quickfix window (:copen / :cclose)
"   - Readable defaults, no plugins
" ==========================================================


" --------------------------
" Basic sanity / compatibility
" --------------------------
set nocompatible                  " Use modern Vim behavior
set encoding=utf-8                " UTF-8 everywhere
set backspace=indent,eol,start    " Backspace works as expected


" --------------------------
" User interface
" --------------------------
syntax on                         " Syntax highlighting
set number                        " Absolute line numbers
set relativenumber                " Relative numbers (good for motions)
set cursorline                    " Highlight current line
set showcmd                       " Show partial command in status bar
set ruler                         " Show cursor position
set wildmenu                      " Visual command-line completion menu
set wildmode=longest:full,full    " Better tab-completion behavior


" --------------------------
" Mouse support
" --------------------------
" Enables mouse usage:
"   - Click to move cursor
"   - Select text
"   - Switch between splits/panes
" Works well over SSH and inside tmux
set mouse=a


" --------------------------
" Search behavior
" --------------------------
set hlsearch                      " Highlight search matches
set incsearch                     " Incremental search as you type
set ignorecase                    " Case-insensitive search...
set smartcase                     " ...unless uppercase is used


" --------------------------
" Indentation (safe defaults)
" --------------------------
set autoindent                    " Copy indent from current line
set smartindent                   " Smarter indentation for code
set tabstop=4                     " A tab is 4 spaces
set shiftwidth=4                  " Indent by 4 spaces
set expandtab                     " Use spaces instead of tabs


" --------------------------
" Recursive file search (:find)
" --------------------------
" This makes :find behave like a simple fuzzy file finder.
"
" Example:
"   :find train.py<Tab>
"
" Vim will recursively search from the current directory.
"
set path+=**


" Ignore common junk directories when searching files
set wildignore+=*/.git/*
set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.o,*.pyc,*.so


" --------------------------
" Grep integration (:grep)
" --------------------------
" :grep searches for text across files and stores results
" in the *quickfix list*.
"
" The quickfix list is a global list of locations (file:line)
" that you can jump through.
"
" After :grep:
"   :copen   -> open quickfix window
"   :cclose  -> close quickfix window
"   :cnext   -> next match
"   :cprev   -> previous match
"
" We prefer ripgrep (rg) if available because it is fast.
"

if executable('rg')
  " Use ripgrep in Vim-compatible output mode
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
elseif executable('grep')
  " Fallback to standard recursive grep
  set grepprg=grep\ -RIn
endif


" Automatically open the quickfix window after :grep
autocmd QuickFixCmdPost grep cwindow


" --------------------------
" Quickfix navigation helpers
" --------------------------
" These mappings make quickfix usage easy and memorable.
"
"   ]q / [q     -> next / previous quickfix entry
"   <leader>q   -> open quickfix window
"   <leader>Q   -> close quickfix window
"
let mapleader = " "

nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap <leader>q :copen<CR>
nnoremap <leader>Q :cclose<CR>


" --------------------------
" File & search helpers
" --------------------------
" Quickly start file search:
"   <leader>f  -> :find ...
nnoremap <leader>f :find

" Quickly start grep:
"   <leader>g  -> :grep ...
nnoremap <leader>g :grep

" Change working directory to current file's folder.
" Useful to limit :find and :grep scope.
"
" Example:
"   <leader>cd
"
nnoremap <leader>cd :lcd %:p:h<CR>


" --------------------------
" Colors (tmux / SSH friendly)
" --------------------------
set t_Co=256
if has('termguicolors')
  set termguicolors
endif
set background=dark
