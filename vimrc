""" --- Minimal Vim config (portable, server-friendly) ---

" 1. SEARCH & PATH CONFIGURATION
" Set path to recursive, but we will use wildignore to keep it fast
set path=.,,**
set wildmenu
set wildignorecase
" Ignore common noise so :find doesn't get bogged down
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*,*.o,*.pyc,*.swp

" Use fd/fdfind to make command-line completion (Tab) much faster
if executable('fdfind')
    " Ubuntu logic
    let $FZF_DEFAULT_COMMAND = 'fdfind --type f'
    set wildoptions=pum " Modern popup menu for completion
elseif executable('fd')
    " Standard logic
    let $FZF_DEFAULT_COMMAND = 'fd --type f'
    set wildoptions=pum
endif

" 2. INTERFACE & SEARCH BEHAVIOR
set number rnu                 " Hybrid line numbers
set hlsearch incsearch         " Search as you type + highlight matches
syntax on                     " Syntax highlighting

" 3. INDENTATION & MOUSE
set autoindent                " Basic indentation
set tabstop=4 shiftwidth=4 expandtab
set mouse=a                   " Enable mouse (splits/panes, selection)

" 4. GREP CONFIGURATION (Ripgrep)
if executable('rg')
  " --vimgrep: file:line:col:text
  " --smart-case: case-insensitive unless uppercase used
  " --no-heading: removes grouped headers so Vim can parse lines
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('grep')
  set grepprg=grep\ -RIn
endif
