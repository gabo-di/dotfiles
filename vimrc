" --- Minimal Vim config (portable, server-friendly) ---

" 1) SEARCH & PATH CONFIGURATION
set path=.,**
set wildmenu
set wildignorecase
" Ignore common noise so completion/:find doesn't get bogged down
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*,*.o,*.pyc,*.swp,*.pyc

" Fast file finder using fd/fdfind (recommended on servers)
" Usage:
"   :FF <pattern>      (uses fd, opens file if unique, else quickfix list)
if executable('fdfind') || executable('fd')
  let s:fd = executable('fdfind') ? 'fdfind' : 'fd'

  function! s:FastFind(pat) abort
    " Search from current directory downward.
    " --hidden/--follow help in repos; excludes keep it fast/clean.
    let l:cmd = s:fd
          \ . ' --type f --hidden --follow'
          \ . ' --exclude .git --exclude node_modules --exclude __pycache__'
          \ . ' ' . shellescape(a:pat) . ' .'

    let l:files = systemlist(l:cmd)

    if v:shell_error != 0
      echohl ErrorMsg | echom 'fd error: ' . l:cmd | echohl None
      return
    endif

    if empty(l:files)
      echohl WarningMsg | echom 'No match: ' . a:pat | echohl None
      return
    endif

    if len(l:files) == 1
      execute 'edit ' . fnameescape(l:files[0])
      return
    endif

    " Multiple matches -> quickfix list
    call setqflist([], 'r', {'title': 'FF: ' . a:pat, 'lines': l:files})
    copen
  endfunction

  command! -nargs=1 -complete=file FF call s:FastFind(<q-args>)
endif

" 2) INTERFACE & SEARCH BEHAVIOR
set number rnu
set hlsearch incsearch
syntax on

" 3) INDENTATION & MOUSE
set autoindent
set tabstop=4 shiftwidth=4 expandtab
set mouse=a

" 4) GREP CONFIGURATION (Ripgrep)
if executable('rg')
  " --vimgrep: file:line:col:text
  " --smart-case: case-insensitive unless uppercase used
  " --no-heading: removes grouped headers so Vim can parse lines
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('grep')
  set grepprg=grep\ -RIn
endif
