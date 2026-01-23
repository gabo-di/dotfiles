""" --- Minimal Vim config (portable, server-friendly) ---

" Use fdfind (Ubuntu) or fd to populate path for :find (much faster than path+=**)
" This allows :find to work instantly across your project while respecting .gitignore
if executable('fdfind')
  let &path = ".,," . substitute(system('fdfind --type d --max-depth 3'), '\n', ',', 'g')
elseif executable('fd')
  let &path = ".,," . substitute(system('fd --type d --max-depth 3'), '\n', ',', 'g')
else
  set path+=**                  " Fallback to recursive search if fd is missing
endif

set wildmenu                  " Visual menu for command-line completion
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*,*.o,*.pyc

set number rnu                 " Hybrid line numbers
set hlsearch incsearch         " Search as you type + highlight matches
syntax on                     " Syntax highlighting

set autoindent                " Basic indentation
set tabstop=4 shiftwidth=4 expandtab
set mouse=a                   " Enable mouse (splits/panes, selection)

" Make :grep use ripgrep (rg) for speed and ignore noise like .git/node_modules
if executable('rg')
  " --vimgrep: matches format Vim expects (file:line:col:text)
  " --smart-case: case-insensitive unless uppercase is used
  " --no-heading: required for Vim to parse the list correctly
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('grep')
  set grepprg=grep\ -RIn
endif
