" --- Minimal Vim config (portable, server-friendly) ---

set path+=**                  " Recursive file search for :find
set wildmenu                  " Visual menu for command-line completion
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*,*.o,*.pyc

set number rnu                 " Hybrid line numbers
set hlsearch incsearch         " Search as you type + highlight matches
syntax on                     " Syntax highlighting

set autoindent                " Basic indentation
set tabstop=4 shiftwidth=4 expandtab
set mouse=a                   " Enable mouse (splits/panes, selection)

" Make :grep simple and recursive (like :find)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
elseif executable('grep')
  set grepprg=grep\ -RIn
endif

